//
//  EntryPointRuleTests.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import XCTest

@testable import Lexer

// Test Cases
// 1. Code Linitng returned something
// 2. CodeLinting returned nil
//    1. Char was read successfully
// 3. Stream is over
final class EntryPointRuleTests: XCTestCase {
    
    func testCodeLintingReturnedSmth() throws {
        // Arrange
        
        let codeLiniterStub = StubRule<CodeLintingNode?>(runCommand: {
            var strCopy = $0.copy()
            _ = strCopy.pop()
            _ = strCopy.pop()
            _ = strCopy.pop()
            return .init(value: .codeInliningBody(.number(1)), stream: strCopy)
        })
        
        let rule = FileBodyRule(codeLintingRule: codeLiniterStub.erase(), readCahrRule: ReadCharRule().erase())
    
    
        let string = "12345678"
        let stream = try StringStream(rawString: string)
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.stream.current(), "4")
        XCTAssertNotNil(result.value)
        
        switch result.value! {
        case .codeInline(_):
            return
        case .char(let c):
            XCTFail("Expected codeInline but got char \(c) token")
        }
    }
    
    func testCodeLintingReturnedNil() throws {
        // Arrange
        
        let codeLiniterStub = StubRule<CodeLintingNode?>(runCommand: { return .init(value: nil, stream: $0) })
        
        let rule = FileBodyRule(codeLintingRule: codeLiniterStub.erase(), readCahrRule: ReadCharRule().erase())
    
    
        let string = "12345678"
        let stream = try StringStream(rawString: string)
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.stream.current(), "2")
        XCTAssertNotNil(result.value)
        
        switch result.value! {
        case .codeInline(let val):
            XCTFail("Expected CHAR but got code inlining \(val) token")
        case .char(let c):
            XCTAssertEqual(c, "1")
        }
    }
    
    func testStreamIsOver() throws {
        // Arrange
        
        let codeLiniterStub = StubRule<CodeLintingNode?>(runCommand: { return .init(value: nil, stream: $0) })
        
        let rule = FileBodyRule(codeLintingRule: codeLiniterStub.erase(), readCahrRule: ReadCharRule().erase())
    
    
        let string = "12345678"
        var stream = try StringStream(rawString: string)
        stream.moveForward(on: string.count)
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertNil(result.value)
        XCTAssertTrue(result.stream.isFinished())
    }
    
}
