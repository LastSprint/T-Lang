//
//  ObjectTree.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

public struct FuncCallNode: CustomDebugStringConvertible {
    public let name: String
    public let args: [ExpressionNode]
    
    public var debugDescription: String {
        return "\(ASTToken.funcCall)[\(name); \(args)]"
    }
    
    public init(name: String, args: [ExpressionNode]) {
        self.name = name
        self.args = args
    }
}

public enum LiteralNode: CustomDebugStringConvertible {
    
    case number(Double)
    case string(String)
    
    public var debugDescription: String {
        switch self {
        case .number(let double):
            return "\(ASTToken.number)[\(double)]"
        case .string(let string):
            return "\(ASTToken.string)[\(string)]"
        }
    }
}

public enum ExpressionNode: CustomDebugStringConvertible {
    case literal(LiteralNode)
    case anyName(String)
    case funcCall(FuncCallNode)
    
    public var debugDescription: String {
        switch self {
        case .literal(let literalNode):
            return literalNode.debugDescription
        case .anyName(let string):
            return string
        case .funcCall(let funcCallNode):
            return funcCallNode.debugDescription
        }
    }
}

public enum CodeInliningBodyLine: CustomDebugStringConvertible {
    case number(Double)
    case string(String)
    
    public var debugDescription: String {
        switch self {
        case .number(let double):
            return "\(ASTToken.number)[\(double)]"
        case .string(let string):
            return "\(ASTToken.string)[\(string)]"
        }
    }
}

public enum CodeInliningNode: CustomDebugStringConvertible {
    case codeInliningBody([CodeInliningBodyLine])
    
    public var debugDescription: String {
        switch self {
        case .codeInliningBody(let array):
            return "\(ASTToken.codeInliningBody)[" + array.map { $0.debugDescription }.joined() + "]"
        }
    }
}

public enum FileBodyNode: CustomDebugStringConvertible {
    case codeInline(CodeInliningNode)
    case char(Character)
    
    public var debugDescription: String {
        let res = "\(ASTToken.fileBodyNode)"
        switch self {
        case .codeInline(let codeInliningNode):
            return "\(res)[\(codeInliningNode.debugDescription)]"
        case .char(let character):
            return "\(res)[\(ASTToken.char)[\(character)]]"
        }
    }
}
