//
//  AnyNameRule.swift
//  
//
//  Created by Александр Кравченков on 06.01.2022.
//

import Foundation
import Common

/// Tries to read name character by chracter
/// Finish reading and return what was read if found forbidden character
///
/// Permitted characters:
/// - `letter` -> `[a-z] [A-Z] _`
/// - `number` -> `[0-9]` but not as first symbol in name
///
/// Examples of good input:
/// - `variableName`
/// - `_funcName`
/// - `item2`
///
/// Examples if bad input:
/// - `1varName`
/// - `func-name`
/// - `sd*sdf`
/// - ...
struct AnyNameRule: Rule {
    
    func run(with stream: SymbolStream) throws -> StreamResult<String?, SymbolStream> {
        
        var streamCopy = stream
        var result = ""
        
        while true {
            guard let char = streamCopy.pop() else {
                break
            }
            
            guard !Consts.nameCharactersSet.contains(char) else {
                result.append(char)
                continue
            }
            
            guard !result.isEmpty else {
                return .init(value: nil, stream: stream)
            }
            
            guard !Consts.numbersCharaterSet.contains(char) else {
                result.append(char)
                continue
            }
            
            break
        }
        
        guard !result.isEmpty else {
            return .init(value: nil, stream: stream)
        }
        
        return .init(value: result, stream: streamCopy)
    }
}
