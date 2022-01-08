//
//  NumberParserRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

/// This rule parses number from stream
/// Bbut there are some specialities which you have to know about
/// 1. The rule is - [0-9]+("."[0-9+])* it means that number should be started from number. In other cases it wont be parsed
/// 2. If number will have two dots -> `123.123.123` then it will return Double(123.123) and stream with pointer on second dot
/// 3. If stream will have number with other characters after - it wll try parse number and return it. For example:
///     123.234sdf it will be parsed as `Double(123.234)` and strean pointer will be set on `s`
///
/// So in other words => Try parse number and can return nill only if there is no number here
///
/// For more details see `NumberParserRuleTests`
struct NumberParserRule: Rule {
    
    func run(with stream: SymbolStream) throws -> StreamResult<Double?, SymbolStream> {
        var streamCopy = stream.copy()
        streamCopy.skipSpaces()
        
        var haveDot = false
        var resultString = ""
        
        while true {
            
            guard let current = streamCopy.current() else {
                break
            }
            
            if current == "." && !haveDot && !resultString.isEmpty {
                resultString.append(current)
                haveDot = true
                _ = streamCopy.pop()
                continue
            }
            
            guard Consts.numbersCharaterSet.contains(current) else { break }
            
            resultString.append(current)
            _ = streamCopy.pop()
        }
        
        guard !resultString.isEmpty else { return .init(value: nil, stream: stream) }
        
        if let lastSymbol = resultString.last, !Consts.numbersCharaterSet.contains(lastSymbol) {
            resultString = String(resultString.dropLast())
            streamCopy.moveBack(on: 1)
        }
        
        guard let number = Double(resultString) else {
            throw CommonError(message: "Liter \(resultString) can't be converted to number\n\(stream)")
        }
        
        return .init(value: number, stream: streamCopy)
    }
}
