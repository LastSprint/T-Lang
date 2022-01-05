//
//  EntryPointRule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

public struct FileBodyRule: Rule {
    
    let codeLintingRule: AnyRule<CodeLintingNode?>
    let readCahrRule: AnyRule<Character?>
    
    func run(with stream: SymbolStream) throws -> StreamResult<FileBodyNode?, SymbolStream> {
        
        let codeLinting = try wrap(
            self.codeLintingRule.run(with: stream),
            message: "While parsing code linting rules got error"
        )
        
        if let guarded = codeLinting.value {
            return .init(value: .codeInline(guarded), stream: codeLinting.stream)
        }
        
        let charRes = try wrap(
            self.readCahrRule.run(with: stream),
            message: "While parsing CHAR token"
        )
        
        guard let char = charRes.value else {
            return .init(value: nil, stream: stream)
        }
        
        return .init(value: .char(char), stream: charRes.stream)
    }
}
