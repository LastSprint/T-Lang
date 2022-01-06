//
//  CodeInliningBodyLineRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

/// Can parse one inline expression
/// Or returns nill othrewise
struct CodeInliningExpressionRule: Rule {
    
    let numberParserRule: AnyRule<Double?>
    let stringParserRule: AnyRule<String?>
    
    func run(with stream: SymbolStream) throws -> StreamResult<CodeInliningBodyLine?, SymbolStream> {
        
        let numberResult = try wrap(self.numberParserRule.run(with: stream), message: "While parsing number in code line")
        
        if let number = numberResult.value {
            return .init(value: .number(number), stream: numberResult.stream)
        }

        let stringResult = try wrap(self.stringParserRule.run(with: stream), message: "While parsing string in code line")
        
        if let string = stringResult.value {
            return .init(value: .string(string), stream: stringResult.stream)
        }
        
        return .init(value: nil, stream: stream)
        
    }
}
