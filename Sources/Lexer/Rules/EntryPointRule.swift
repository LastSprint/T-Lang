//
//  EntryPointRule.swift
//  
//
//  Created by Александр Кравченков on 06.01.2022.
//

import Foundation
import Common

/// Collect tokens from file into array
/// it's like a root node for file
struct EntryPointRule: Rule {
    let next: AnyRule<FileBodyNode?>
    
    func run(with stream: SymbolStream) throws -> StreamResult<[FileBodyNode], SymbolStream> {
        
        var streamCopy = stream.copy()
        
        var result = [FileBodyNode]()
        
        while true {
            let bodyItem = try wrap(
                next.run(with: streamCopy),
                message: "While parsing file content"
            )
            
            guard let val = bodyItem.value else {
                break
            }
            
            result.append(val)
            streamCopy = bodyItem.stream
        }
        
        guard !streamCopy.isFinished() else {
            return .init(value: result, stream: streamCopy)
        }
        
        throw CommonError(message: "Something went wrong and after reading file content stream isn't empty. This is wrong and behavior could be unpredicatable\n\(streamCopy)")
    }
}
