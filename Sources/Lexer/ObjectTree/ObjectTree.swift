//
//  ObjectTree.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

enum CodeInliningBodyLine: CustomDebugStringConvertible {
    case number(Double)
    case string(String)
    
    var debugDescription: String {
        switch self {
        case .number(let double):
             return "NM[\(double)]"
        case .string(let string):
            return "STR[\(string)]"
        }
    }
}

enum CodeInliningNode: CustomDebugStringConvertible {
    case codeInliningBody([CodeInliningBodyLine])
    
    var debugDescription: String {
        switch self {
        case .codeInliningBody(let array):
            return "CIB[" + array.map { $0.debugDescription }.joined() + "]"
        }
    }
}

enum FileBodyNode: CustomDebugStringConvertible {
    case codeInline(CodeInliningNode)
    case char(Character)
    
    var debugDescription: String {
        let res = "FBN"
        switch self {
        case .codeInline(let codeInliningNode):
            return "\(res)[\(codeInliningNode.debugDescription)]"
        case .char(let character):
            return "\(res)[CHR[\(character)]]"
        }
    }
}
