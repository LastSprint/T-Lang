//
//  ObjectTree.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

enum CodeInliningBody {
    case number(Double)
    case string(String)
}

enum CodeLintingNode {
    case codeInliningBody(CodeInliningBody)
}

enum FileBodyNode {
    case codeInline(CodeLintingNode)
    case char(Character)
}
