//
//  SourceEditorCommand.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 04/06/23.
//

import Foundation
import XcodeKit
import OpenAISwift

enum CustomError: Error {
    case invalidSelection
    case networkError
    case databaseError
    // Add more cases as needed
}


class ImproveMyCode: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        print("ImproveMyCode: \(invocation.description)")
        print("ImproveMyCode: \(invocation.commandIdentifier)")
        
        guard let selectedText = getSelectedText(source: invocation.buffer) else {
            completionHandler(CustomError.invalidSelection)
            return
        }
        
        switch invocation.commandIdentifier {
        case "SOLIDprinciple":
            checkIfQualifiesSOlidPrinciple(selectedText:selectedText, source: invocation.buffer, completionHandler: completionHandler)
            return
            
        case "WriteUnitTests":
            writeUnitTests(selectedText:selectedText, source: invocation.buffer, completionHandler: completionHandler)
            return
            
        default:
            completionHandler(CustomError.invalidSelection)
            return
        }
    }
    
    private func getSelectedText(source: XCSourceTextBuffer) -> String? {
        guard let selection = source.selections.firstObject as? XCSourceTextRange else {
            // Send proper error
            return nil
        }
        
        print(selection.start.line, selection.start.column)
        print(selection.end.line, selection.end.column)
        
        if let selection = source.selections.firstObject as? XCSourceTextRange, selection.start.line < source.lines.count {
            var selectionString = ""
            for lineIndex in selection.start.line...selection.end.line {
                let selectedLine = source.lines[lineIndex] as? String
                if let line = selectedLine {
                    selectionString.append("\n\(line)")
                }
            }
            return selectionString
        }
        
        return nil
    }
    
    private func checkIfQualifiesSOlidPrinciple(selectedText: String,
                                                source: XCSourceTextBuffer,
                                                completionHandler: @escaping (Error?) -> Void) {
        if let selection = source.selections.firstObject as? XCSourceTextRange, selection.start.line < source.lines.count {
            let solidPrincipleService = SolidPrinciple()
            solidPrincipleService.getResultForTheCommand(selectedText: selectedText) { [weak self] result in
                switch result {
                case .success(let message):
                    DispatchQueue.main.async { [weak self] in
                        let output = (self?.indentation(line: source.lines[selection.start.line] as! String) ?? "")
                        let finalText = output + "\(message)"
                        
                        print("Final text is --\n " + finalText)
                        source.lines.insert(finalText, at: selection.end.line + 1)
                        completionHandler(nil)
                        return
                    }
                    
                case .failure(let error):
                    completionHandler(error)
                    return
                }
            }
        }
        
        completionHandler(CustomError.invalidSelection)
    }
    
    private func writeUnitTests(selectedText: String,
                                source: XCSourceTextBuffer,
                                completionHandler: @escaping (Error?) -> Void) {
        
        if let selection = source.selections.firstObject as? XCSourceTextRange, selection.start.line < source.lines.count {
            
            let unitTestsService = WriteUnitTests()
            
            unitTestsService.getResultForTheCommand(selectedText: selectedText) { [weak self] result in
                switch result {
                case .success(let message):
                    DispatchQueue.main.async { [weak self] in
                        let output = (self?.indentation(line: source.lines[selection.start.line] as! String) ?? "")
                        let finalText = output + "\(message)"
                        
                        print("Final text is --\n " + finalText)
                        source.lines.insert(finalText, at: selection.end.line + 1)
                        completionHandler(nil)
                        return
                    }
                    
                case .failure(let error):
                    completionHandler(error)
                    return
                }
            }
        }
        
        completionHandler(CustomError.invalidSelection)
    }
    
    private func indentation(line: String) -> String {
        if let nonWhitespace = line.rangeOfCharacter(from: CharacterSet.whitespaces.inverted) {
            return String(line.prefix(upTo: nonWhitespace.lowerBound))
        } else {
            return ""
        }
    }
    
}
