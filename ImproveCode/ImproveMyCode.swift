//
//  SourceEditorCommand.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 04/06/23.
//

import Foundation
import XcodeKit

enum CommandType: String {
    case solidPrinciple = "SOLIDprinciple"
    case writeUnitTests = "WriteUnitTests"
    case unknown = "Unknown"
}

class ImproveMyCode: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        print("ImproveMyCode: \(invocation.description)")
        print("ImproveMyCode: \(invocation.commandIdentifier)")

        guard let selectedText = TextSelection.getSelectedText(source: invocation.buffer) else {
            completionHandler(CustomError.invalidSelection)
            return
        }
        
        
        let source = invocation.buffer
        guard let selection = source.selections.firstObject as? XCSourceTextRange, selection.start.line < source.lines.count else {
            completionHandler(CustomError.invalidSelection)
            return
        }
            
        
        switch invocation.commandIdentifier {
        case CommandType.solidPrinciple.rawValue:
            checkIfQualifiesSOlidPrinciple(selectedText:selectedText, 
                                           selection: selection,
                                           source: invocation.buffer,
                                           completionHandler: completionHandler)
            return
            
        case CommandType.writeUnitTests.rawValue:
            writeUnitTests(selectedText:selectedText, 
                           selection: selection,
                           source: invocation.buffer,
                           completionHandler: completionHandler)
            return
            
        default:
            completionHandler(CustomError.invalidSelection)
            return
        }
    }
    
    private func checkIfQualifiesSOlidPrinciple(selectedText: String,
                                                selection: XCSourceTextRange,
                                                source: XCSourceTextBuffer,
                                                completionHandler: @escaping (Error?) -> Void) {
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
    
    private func writeUnitTests(selectedText: String,
                                selection: XCSourceTextRange,
                                source: XCSourceTextBuffer,
                                completionHandler: @escaping (Error?) -> Void) {
        
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
    
    private func indentation(line: String) -> String {
        if let nonWhitespace = line.rangeOfCharacter(from: CharacterSet.whitespaces.inverted) {
            return String(line.prefix(upTo: nonWhitespace.lowerBound))
        } else {
            return ""
        }
    }
    
}


