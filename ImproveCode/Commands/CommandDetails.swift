//
//  CommandDetails.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 29/04/24.
//

import Foundation
import XcodeKit

enum CommandType: String {
    case generateCode = "GenerateCode"
    case writeUnitTests = "WriteUnitTests"
    case unknown = "Unknown"
    
    static func getCommand(forIdentifier identifier: String) -> CommandType {
        switch identifier {
        case CommandType.generateCode.rawValue:
            return .generateCode
            
        case CommandType.writeUnitTests.rawValue:
            return .writeUnitTests
        
        default:
            return .unknown
        }
    }
}

struct CommandDetails {
    var identifier: String
    var selectedText: String
    var selection: XCSourceTextRange
    var source: XCSourceTextBuffer
    
    static func getDetails(from invocation: XCSourceEditorCommandInvocation) -> CommandDetails? {
        guard let selectedText = TextSelection.getSelectedText(source: invocation.buffer) else {
            return nil
        }
        
        let source = invocation.buffer
        guard let selection = source.selections.firstObject as? XCSourceTextRange, selection.start.line < source.lines.count else {
            return nil
        }
        
        return CommandDetails(identifier: invocation.commandIdentifier,
                              selectedText: selectedText,
                              selection: selection,
                              source: invocation.buffer)
    }
}
