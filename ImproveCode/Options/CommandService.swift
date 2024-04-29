//
//  CommandService.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 10/06/23.
//

import Foundation

enum CustomError: Error {
    case invalidSelection
    case networkError
    case databaseError
    // Add more cases as needed
}

protocol CustomCommandService {
    var rules: String { get }
    
    func getResultForTheCommand(selectedText: String, completionHandler: @escaping (Result<String, Error>) -> Void)
}
