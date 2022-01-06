//
//  KeySymbols.swift
//
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

enum ConstantsTokens: String, CaseIterable {
    case codeInliningBegin = "@{"
    case codeInliningEnd = "}"
    case stringDelimeter = "\""
    case newLine = "\n"
    
    static func readToken(token: ConstantsTokens, stream: SymbolStream) -> StreamResult<Bool, SymbolStream> {
        
        var streamCopy = stream
        
        for it in token.rawValue {
            guard
                let char = streamCopy.pop(),
                it == char
            else {
                return .init(value: false, stream: stream)
            }
        }
        
        return .init(value: true, stream: streamCopy)
    }

    
    static func getAppropriateTokens<T: StringProtocol>(tokens: [T], symbol: Character, index: Int) -> [T] {
        return tokens.filter { it in
            guard it.count > index else {
                return false
            }
            
            let caseItemIndex = it.index(it.startIndex, offsetBy: index)
            
            return it[caseItemIndex] == symbol
        }
    }
    
    static func findToken<V: StringProtocol, S: SymbolStream>(tokens: [V], stream: S, index: Int) throws -> StreamResult<V?, S> {
        
        var streamCopy = stream.copy()
        
        guard let current = streamCopy.pop() else {
            return .init(value: nil, stream: stream)
        }
        
        let appropriate = ConstantsTokens.getAppropriateTokens(tokens:tokens, symbol: current, index: index)
        
        guard appropriate.count != 0 else {
            return .init(value: nil, stream: stream)
        }
        
        let resultToken = try ConstantsTokens.findToken(tokens: appropriate, stream: streamCopy, index: index + 1)
        
        guard resultToken.value == nil else {
            return resultToken
        }
        
        let fullMatched = appropriate.filter { $0.count == index + 1 }
        
        if fullMatched.count == 0 {
            return .init(value: nil, stream: stream)
        } else if fullMatched.count == 1 {
            return .init(value: fullMatched.first, stream: streamCopy)
        } else {
            throw CommonError(message: "Something went wrong while searching tokens. We can't choose approprate token from: \(fullMatched)\n\(stream)")
        }
    }
}

//enum KeySymbol {
//    case char(Character)
//    case number(String)
//    case string(String)
//    case codeInliningBegin
//    case codeInliningEnd
//
//    static func readSymbol(from stream: SymbolStream) -> KeySymbol? {
//        if stream.isFinished() {
//            return nil
//        }
//    }
//
//    func tryReadConstantToken(from stream: inout SymbolStream) -> KeySymbol? {
//
//    }
//}


