//
//  Rule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import XCTest

protocol Rule {
    
    associatedtype Result
    
    func run(with stream: SymbolStream) throws -> StreamResult<Result, SymbolStream>
}

extension Rule {
    public func erase() -> AnyRule<Result> {
        return .init(nested: self)
    }
}

// Just a Box for any specific type of PipelineEntryPoint
struct AnyRule<Result>: Rule {

    private let nested: _RuleBox<Result>

    init<Nested: Rule>(nested: Nested) where Nested.Result == Result{
        self.nested = _Rule(nested: nested)
    }

    func run(with stream: SymbolStream) throws -> StreamResult<Result, SymbolStream> {
        return try self.nested.run(with: stream)
    }
}

internal class _RuleBox<Result>: Rule {

    @usableFromInline
    func run(with stream: SymbolStream) throws -> StreamResult<Result, SymbolStream> {
        fatalError("Abstract method was called")
    }
}

internal class _Rule<Nested: Rule>: _RuleBox<Nested.Result> {
    let nested: Nested

    init(nested: Nested) {
        self.nested = nested
    }

    override  func run(with stream: SymbolStream) throws -> StreamResult<Result, SymbolStream> {
        return try self.nested.run(with: stream)
    }
}
