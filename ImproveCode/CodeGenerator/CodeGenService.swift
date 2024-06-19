//
//  CodeGenService.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 19/06/24.
//

import Foundation

protocol CodeGenService {
    func getResponse(for prompt: String,
                     with rules: String,
                     completion: @escaping (Result<String, Error>) -> Void)
}
