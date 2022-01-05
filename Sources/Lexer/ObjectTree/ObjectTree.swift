//
//  ObjectTree.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

enum CodeInliningBodyLine {
    case number(Double)
    case string(String)
}

enum CodeInliningNode {
    case codeInliningBody([CodeInliningBodyLine])
}

enum FileBodyNode {
    case codeInline(CodeInliningNode)
    case char(Character)
}
