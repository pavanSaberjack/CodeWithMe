//
//  SourceEditorCommand.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 04/06/23.
//

import Foundation
import XcodeKit

class ImproveMyCode: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        setUp()
        
        print("ImproveMyCode: \(invocation.description)")
        print("ImproveMyCode: \(invocation.commandIdentifier)")

        guard let commandDetail = CommandDetails.getDetails(from: invocation) else {
            completionHandler(CustomError.networkError)
            return
        }
        
        runCommand(command: commandDetail,
                   completionHandler: completionHandler)
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
}

/// Initialiasation
extension ImproveMyCode {
    private func setUp() {
        CommandManager.shared.add(commandService: SolidPrinciple(), forType: .solidPrinciple)
        CommandManager.shared.add(commandService: WriteUnitTests(), forType: .writeUnitTests)
    }
}

extension ImproveMyCode {
    private func indentation(line: String) -> String {
        if let nonWhitespace = line.rangeOfCharacter(from: CharacterSet.whitespaces.inverted) {
            return String(line.prefix(upTo: nonWhitespace.lowerBound))
        } else {
            return ""
        }
    }
}

extension ImproveMyCode {
    private func runCommand(command: CommandDetails,
                            completionHandler: @escaping (Error?) -> Void) {

        let type = CommandType.getCommand(forIdentifier: command.identifier)

        CommandManager.shared.getResult(forCommandType: type,
                                        selectedText: command.selectedText) { [weak self] result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async { [weak self] in
                    let output = (self?.indentation(line: command.source.lines[command.selection.start.line] as! String) ?? "")
                    let finalText = output + "\(message)"

                    print("Final text is --\n " + finalText)
                    command.source.lines.insert(finalText, at: command.selection.end.line + 1)
                    completionHandler(nil)
                    return
                }
                
            case .failure(let error):
                completionHandler(error)
                return
            }
        }
    }
}


