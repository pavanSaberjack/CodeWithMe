//
//  CodeWithMeService.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 19/06/24.
//

import Foundation

enum CodeWithMeServiceError: Error {
    case invalidData
    case invalidResponse
}

final class CodeWithMeService: CodeGenService {
    var usertoken: String?
    
    func getResponse(for prompt: String,
                     with rules: String,
                     completion: @escaping (Result<String, any Error>) -> Void) {
        
        usertoken = "User Token";
        
        // TODO: Fix the authentication flow here
        
        let params = ["messages": prompt] as Dictionary<String, String>
        
        var request = URLRequest(url: URL(string: "<Base URL>/api/codegen/generate")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(usertoken ?? "")", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            guard let data else {
                completion(.failure(CodeWithMeServiceError.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(CodeWithMeServiceError.invalidResponse))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                completion(.success(json["response"] as! String))
            } catch {
                completion(.failure(error))
            }
        })

        task.resume()
    }
    
    // TODO: Rewrite this code
    private func login(completion: @escaping (Result<String, any Error>) -> Void) {
        let params = ["email":"abc@ab.com", "password":"abcabc"] as Dictionary<String, String>

        var request = URLRequest(url: URL(string: "<Base URL>/api/users/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                
                self?.usertoken = json["token"] as? String
                
            } catch {
                print("error")
            }
        })

        task.resume()
    }
    
}
