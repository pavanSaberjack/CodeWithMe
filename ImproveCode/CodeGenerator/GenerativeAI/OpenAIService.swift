//
//  OpenAIService.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 19/06/24.
//

import Foundation

import OpenAISwift

final class OpenAIService: CodeGenService {
    private var client: OpenAISwift?
    
    private init() {}
    
    func setup() {
        // Don't commit API key
        client = OpenAISwift(authToken: "<Your API Key here>")
    }
    
    func getResponse(for prompt: String, 
                     with rules: String,
                     completion: @escaping (Result<String, any Error>) -> Void) {
        let prompt: ChatMessage = ChatMessage(role: .assistant, content: "\(rules) \n\n \(prompt)")
        
        client?.sendChat(with: [prompt],
                         maxTokens: 500,
                         completionHandler: { result in
            switch result {
            case .success(let message):
                let output = message.choices?.first?.message.content ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
