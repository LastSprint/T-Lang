//
//  ASTTokens.swift
//  
//
//  Created by Александр Кравченков on 07.01.2022.
//

import Foundation

/// Contains AST tokens from `AST Tokens` in grammar
///
/// - See: <doc:Grammar>
enum ASTToken: String, CustomStringConvertible {
    case fileBodyNode = "FBN"
    case codeInliningBody = "CIB"
    case `func` = "FNC"
    case funcArg = "FAG"
    case funcCall = "FCL"
    case number = "NM"
    case string = "STR"
    case char = "CHR"
    
    public var description: String {
        return self.rawValue
    }
}
