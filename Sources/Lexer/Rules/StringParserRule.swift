//
//  StringParserRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

struct StringParserRule: Rule {
    
    func run(with stream: SymbolStream) throws -> StreamResult<String?, SymbolStream> {
        var streamCopy = stream.copy()
        streamCopy.skipSpaces()
        
        let beginResult = ConstantsTokens.readToken(token: .stringDelimeter, stream: streamCopy)
        
        guard beginResult.value else {
            return .init(value: nil, stream: stream)
        }
        
        streamCopy = beginResult.stream
        
        var strContent = ""
        
        while true {
            
            guard let current = streamCopy.current() else {
                throw CommonError(message: "String doesnt have \" in the end\n\(streamCopy)")
            }
            
            let newLine = ConstantsTokens.readToken(token: .newLine, stream: streamCopy)
            
            guard !newLine.value else {
                throw CommonError(message: "String must be single-line\n\(streamCopy)")
            }
            
            let finish = ConstantsTokens.readToken(token: .stringDelimeter, stream: streamCopy)
            
            guard !finish.value else {
                streamCopy = finish.stream
                break
            }
            
            strContent.append(current)
            _ = streamCopy.pop()
        }
        
        return .init(value: strContent, stream: streamCopy)
    }
}
