//
//  OpenAPIManager.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 01/06/23.
//

import Foundation
import OpenAISwift

final class OpenAPIManager {
    static let shared = OpenAPIManager()
    
    private var client: OpenAISwift?
    
    private init() {}
    
    func setup() {
        // Don't commit API key
        client = OpenAISwift(authToken: "<API KEY")
    }
    
    func getResponse(messages: [ChatMessage],
                    completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendChat(with: messages,
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
