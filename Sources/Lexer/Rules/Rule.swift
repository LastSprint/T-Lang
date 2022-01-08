//
//  Rule.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import XCTest

/// # Overview
/// It's a key element of lexer and parser.
///
/// All rules could be found in `Rules` part in <doc:Grammar>
///
/// The main idea is to chain rules in something like tree:
/// ```
/// entry_point_rule:
///  ├── template_rule:
///  |     └── code_inlining_rule:
///  |          └── code_inlining_expression_rule:
///  |                ├── NUMBER
///  |                └── STRING
///  └── CHAR
/// ```
///
/// And if each rule returns AST node then after executing tree of rules we will get tree of AST nodes or just an AST
///
/// # Responsibilities
/// 1. Rule is responsible for parsing something from stream
/// 2. One rule responsible for one specific thing. If you ocassionaly need to return a tuple - you need to create two rules. But returning arrays is ok
/// 3. Rule must parse text only in scope of the rule
///
/// Let's discuss thrid case:
///
/// For example, ypu have stream `variable*` and you need to read variable name (letters)
/// So in your rule ypu have to read string char by char (`v` then `a` etc.) until you reach `*`
/// In this case you have to return what you have read and copy of stream (for details see `run(with: )`)
///
/// Ypu can understant it like "ok, scope of variabel is over. I don;t know what i can do with it because i dont; know waht was before and i dont see "the bigger part of picture" - so lets omebody above me takes the deccision what have to be done with it
///
/// See:
/// - ``AnyRule``
public protocol Rule {
    
    /// Rule applying result
    associatedtype Result
    
    /// Execute rule
    ///
    /// - Parameter stream: character stream. Will be immutable even if it is class
    /// - Returns: read value and copy of symbol stream
    ///
    /// - Note: Common way is pass Result as optional parameter. So if rule failed then in thre result will be nil value
    ///
    /// - Note: Generally if rule was successed then in result will be parsed value and cope of stream with shifted pointer. The pointer will point on next after `value` symbol (it's like "hey, I've read `value` and shifted pointer on number of sybols which I read to read `value`")
    ///
    /// - Note: Generally if rule failed then stream pinter will be at the same place where input strram's pointer was
    func run(with stream: SymbolStream) throws -> StreamResult<Result, SymbolStream>
}

public extension Rule {
    /// Use this method to box any ``Rule`` into ``AnyRule``
    func erase() -> AnyRule<Result> {
        return .init(nested: self)
    }
}

/// Just a Box for any specific type of Rule
/// You have to use this type if ypu want to use ``Rule`` as a property
///
/// For instance:
/// ```Swift
/// struct MyCustomRule: Rule {
///     let nestedRule: AnyRule<String>
///
///     func run(with stream: SymbolStream) throws -> StreamResult<String, SymbolStream> { ... }
/// }
///
/// ...
///
/// let rule = MyCustomRule(AnotherRule().erase())
/// ```
public struct AnyRule<Result>: Rule {

    private let nested: _RuleBox<Result>

    init<Nested: Rule>(nested: Nested) where Nested.Result == Result{
        self.nested = _Rule(nested: nested)
    }

    public func run(with stream: SymbolStream) throws -> StreamResult<Result, SymbolStream> {
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
