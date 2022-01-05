//
//  CodeInliningRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

struct CodeInliningRule: Rule {
    
    let bodyLineRule: AnyRule<CodeInliningBodyLine?>
    
    func run(with stream: SymbolStream) throws -> StreamResult<CodeInliningNode?, SymbolStream> {
        
        var streamCopy = stream.copy()
        
        let beginToken = ConstantsTokens.readToken(token: .codeInliningBegin, stream: streamCopy)
        
        guard beginToken.value else {
            return .init(value: nil, stream: stream)
        }
        
        streamCopy = beginToken.stream
        
        var nested = [CodeInliningBodyLine]()
        
        var exit = false
        
        while !exit {
            
            let bodyLineResult = try wrap(
                self.bodyLineRule.run(with: streamCopy),
                message: "While parsing code_inlining_body_rule"
            )
            
            if let line = bodyLineResult.value {
                nested.append(line)
            }
            
            streamCopy = bodyLineResult.stream
            
            streamCopy.skipSpaces()
            
            let finishToken = ConstantsTokens.readToken(token: .codeInliningEnd, stream: streamCopy)
            
            guard !finishToken.value else {
                exit = true
                streamCopy = finishToken.stream
                break
            }
            
            if bodyLineResult.value == nil {
                throw CommonError(message: "Code inlining must have close sybol `#}~ in the end\n\(streamCopy)")
            }
        }
        
        return .init(value: .codeInliningBody(nested), stream: streamCopy)
    }
}
