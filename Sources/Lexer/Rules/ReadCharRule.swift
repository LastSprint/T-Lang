//
//  ReadCharRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

struct ReadCharRule: Rule {
    
    func run(with stream: SymbolStream) throws -> StreamResult<Character?, SymbolStream> {
        var streamCopy = stream.copy()
        return .init(value: streamCopy.pop(), stream: streamCopy)
    }
}
