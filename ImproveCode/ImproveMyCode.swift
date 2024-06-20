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

        guard let commandDetails = CommandDetails.getDetails(from: invocation) else {
            completionHandler(CustomError.networkError)
            return
        }
        
        runCommand(command: commandDetails,
                   completionHandler: completionHandler)
    }
}

/// Initialiasation
extension ImproveMyCode {
    /// Initial setup and adding commands
    private func setUp() {
        CommandManager.shared.add(commandService: GenerateCode(), forType: .generateCode)
        CommandManager.shared.add(commandService: WriteUnitTests(), forType: .writeUnitTests)
        
        CodeGenManager.shared.codeGenService = CodeWithMeService()
    }
}

/// Handle commands
extension ImproveMyCode {
    private func runCommand(command: CommandDetails,
                            completionHandler: @escaping (Error?) -> Void) {

        let type = CommandType.getCommand(forIdentifier: command.identifier)

        CommandManager.shared.getResult(forCommandType: type,
                                        selectedText: command.selectedText) { result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    let output = (TextSelection.indentation(line: command.source.lines[command.selection.start.line] as! String))
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

//{"messages":" func addTwoNumbers(a: Int, b: Int) -> Int { return a+b }"}
