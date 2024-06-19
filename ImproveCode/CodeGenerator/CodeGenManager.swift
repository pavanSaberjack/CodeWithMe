//
//  CodeGenManager.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 19/06/24.
//

import Foundation

class CodeGenManager: CodeGenService {
    static let shared = CodeGenManager()
    
    var codeGenService: CodeGenService?
    
    func getResponse(for prompt: String,
                     with rules: String,
                     completion: @escaping (Result<String, any Error>) -> Void) {
        codeGenService?.getResponse(for: prompt, with: rules, completion: completion)
    }
}
