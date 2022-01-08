//
//  ExpressionRule.swift
//
//
//  Created by Александр Кравченков on 07.01.2022.
//

import Foundation
import Common

public struct ExpressionRule: Rule {
    
    let literalRule: AnyRule<LiteralNode?>
    let funcCallRule: AnyRule<FuncCallNode?>
    let anyNameRule: AnyRule<String?>
    
    public func run(with stream: SymbolStream) throws -> StreamResult<ExpressionNode?, SymbolStream> {
        
        let literalResult = try wrap(
            self.literalRule.run(with: stream),
            message: "While parsing number"
        )
        
        if let val = literalResult.value {
            return .init(value: .literal(val), stream: literalResult.stream)
        }
        
        let funcCallResult = try wrap(
            self.funcCallRule.run(with: stream),
            message: "While parsing string"
        )
        
        if let val = funcCallResult.value {
            return .init(value: .funcCall(val), stream: funcCallResult.stream)
        }
        
        let anyNameResult = try wrap(
            self.anyNameRule.run(with: stream),
            message: "While parsing string"
        )
        
        if let val = anyNameResult.value {
            return .init(value: .anyName(val), stream: anyNameResult.stream)
        }
        
        return .init(value: nil, stream: stream)
        
    }
}
