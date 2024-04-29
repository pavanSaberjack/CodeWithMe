//
//  SolidPrinciples.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 09/06/23.
//

import Foundation
import XcodeKit
import OpenAISwift

class SolidPrinciple: CustomCommandService {
    var rules: String = """
            ACT as a pair programmer who is helping me in improving my code. Follow the rules.

            1. Only share code snippets.
            2. Anything other than a code snippet should be embedded between "/*" and "*/"
            3. Avoid explanation

            Improve the below code snippet to adhere to the SOLID principle
        """
    
    func getResultForTheCommand(selectedText: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        
        let prompt: ChatMessage = ChatMessage(role: .assistant, content: "\(rules) \n\n \(selectedText)")
        
        OpenAPIManager.shared.setup()
        OpenAPIManager.shared.getResponse(messages: [prompt]) { result in
   
            switch result {
            case .success(let message):
                completionHandler(.success(message))
                return
                
            case .failure(let error):
                completionHandler(.failure(error))
                return
            }
        }
    }
}
