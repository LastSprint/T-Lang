//
//  EntryPointRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

public struct ReadTemplateRule: Rule {
    
    let codeInliningRule: AnyRule<CodeInliningNode?>
    let readCharRule: AnyRule<Character?>
    
    func run(with stream: SymbolStream) throws -> StreamResult<FileBodyNode?, SymbolStream> {
        
        let codeInlining = try wrap(
            self.codeInliningRule.run(with: stream),
            message: "While parsing code linting rules got error"
        )
        
        if let guarded = codeInlining.value {
            return .init(value: .codeInline(guarded), stream: codeInlining.stream)
        }
        
        let charRes = try wrap(
            self.readCharRule.run(with: stream),
            message: "While parsing CHAR token"
        )
        
        guard let char = charRes.value else {
            return .init(value: nil, stream: stream)
        }
        
        return .init(value: .char(char), stream: charRes.stream)
    }
}
