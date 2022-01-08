//
//  FuncCallArgsRule.swift
//  
//
//  Created by Александр Кравченков on 07.01.2022.
//

import Foundation
import Common
import CoreVideo

public class FuncCallArgsRule: Rule {
    public var expressionRule: AnyRule<ExpressionNode?>
    
    public init(expressionRule: AnyRule<ExpressionNode?>) {
        self.expressionRule = expressionRule
    }
    
    public func run(with stream: SymbolStream) throws -> StreamResult<[ExpressionNode], SymbolStream> {
        var resultArgs = [ExpressionNode]()

        var streamCopy = stream.copy()
        streamCopy.skipSpaces()
        repeat {
            let result = try wrap(expressionRule.run(with: streamCopy), message: "While parsing arg")
            guard let parameter = result.value else {
                if resultArgs.count > 1 {
                    // if we here then there was a coma. And we have to parse expressiona after coma
                    throw CommonError(message: "Expected call argument\n\(streamCopy)")
                }
                return .init(value: resultArgs, stream: streamCopy)
            }
            resultArgs.append(parameter)
        } while(streamCopy.current() == ",")
        
        return .init(value: resultArgs, stream: streamCopy)
    }
}
