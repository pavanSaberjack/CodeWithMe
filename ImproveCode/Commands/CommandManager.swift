//
//  CommandManager.swift
//  ImproveCode
//
//  Created by Pavan Itagi on 29/04/24.
//

import Foundation

class CommandManager {
    private(set) var commands = [String: CustomCommandService]()
    
    static let shared = CommandManager()
    private init() {}
    
    func add(commandService: CustomCommandService, forType type: CommandType) {
        self.commands[type.rawValue] = commandService
    }
        
    func getResult(forCommandType type:CommandType,
                   selectedText: String,
                   completionHandler: @escaping (Result<String, any Error>) -> Void) {
        
        guard let service = commands[type.rawValue] else {
            completionHandler(.failure(CustomError.networkError))
            return
        }
        
        service.getResultForTheCommand(selectedText: selectedText,
                                       completionHandler: completionHandler)
        
    }
    
}
