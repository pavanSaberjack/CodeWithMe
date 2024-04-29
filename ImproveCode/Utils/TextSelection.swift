//
//  TextSelection.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 29/04/24.
//

import Foundation
import XcodeKit

class TextSelection {
    class func getSelectedText(source: XCSourceTextBuffer) -> String? {
        guard let selection = source.selections.firstObject as? XCSourceTextRange else {
            // Send proper error
            return nil
        }
        
        print(selection.start.line, selection.start.column)
        print(selection.end.line, selection.end.column)
        
        if let selection = source.selections.firstObject as? XCSourceTextRange, selection.start.line <= source.lines.count {
            var selectionString = ""
            for lineIndex in selection.start.line...selection.end.line {
                let selectedLine = source.lines[lineIndex] as? String
                if let line = selectedLine {
                    selectionString.append("\n\(line)")
                }
            }
            print(selectionString)
            return selectionString
        }
        
        return nil
    }
    
    class func gerSelection(source: XCSourceTextBuffer) -> XCSourceTextRange? {
        if let selection = source.selections.firstObject as? XCSourceTextRange, selection.start.line < source.lines.count {
            return selection
        }
        else {
            return nil
        }
    }
    
    class func indentation(line: String) -> String {
        if let nonWhitespace = line.rangeOfCharacter(from: CharacterSet.whitespaces.inverted) {
            return String(line.prefix(upTo: nonWhitespace.lowerBound))
        } else {
            return ""
        }
    }
}
