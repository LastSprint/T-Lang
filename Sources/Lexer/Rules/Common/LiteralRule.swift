//
//  LiteralRule.swift
//  
//
//  Created by Александр Кравченков on 07.01.2022.
//

import Foundation
import Common

public struct LiteralRule: Rule {
    
    let numberRule: AnyRule<Double?>
    let stringRule: AnyRule<String?>
    
    public func run(with stream: SymbolStream) throws -> StreamResult<LiteralNode?, SymbolStream> {
        
        let numberResult = try wrap(
            self.numberRule.run(with: stream),
            message: "While parsing number"
        )
        
        if let val = numberResult.value {
            return .init(value: .number(val), stream: numberResult.stream)
        }
        
        let strResult = try wrap(
            self.stringRule.run(with: stream),
            message: "While parsing string"
        )
        
        if let val = strResult.value {
            return .init(value: .string(val), stream: strResult.stream)
        }
        
        return .init(value: nil, stream: stream)
    }
}
