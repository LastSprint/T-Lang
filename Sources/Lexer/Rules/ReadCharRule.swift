//
//  ReadCharRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

/// Just read one element from stream if it's possible
/// If read symbol is escaping symbol `\` then it will be slipped and next symbol will be read immidiately
struct ReadCharRule: Rule {
    
    func run(with stream: SymbolStream) throws -> StreamResult<Character?, SymbolStream> {
        var streamCopy = stream.copy()
        
        guard let char = streamCopy.pop() else {
            return .init(value: nil, stream: stream)
        }
        
        guard char == "\\" else {
            return .init(value: char, stream: streamCopy)
        }
        
        return .init(value: streamCopy.pop(), stream: streamCopy)
    }
}
