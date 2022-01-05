//
//  StubRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

@testable import Lexer

class StubRule<T>: Rule {
    
    let runCommand: (SymbolStream) throws -> StreamResult<T, SymbolStream>
    
    init(runCommand: @escaping (SymbolStream) -> StreamResult<T, SymbolStream>) {
        self.runCommand = runCommand
    }
    
    func run(with stream: SymbolStream) throws -> StreamResult<T, SymbolStream> {
        return try self.runCommand(stream)
    }
}
