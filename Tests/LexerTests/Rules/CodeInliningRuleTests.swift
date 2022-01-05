//
//  CodeInliningRuleTests.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import XCTest

@testable import Lexer

// Test Cases:
// 1. No CODE_INLINING_BEGIN
// 2. No code lines but CODE_INLINING_END
// 3. No code lines and no CODE_INLINING_END
// 4. Code lines exists and CODE_INLINING_END
// 5. Code lines exists but CODE_INLINING_END not
final class CodeInliningRuleTests: XCTestCase {
    
    func testNoCodeInliningBegin() throws {
        // Arrange
        
        let stub = StubRule<CodeInliningBodyLine?> { stream in
            return .init(value: .number(1), stream: stream)
        }
        
        let rule = CodeInliningRule(bodyLineRule: stub.erase())
        
        let str = "123#}~"
        let stream = try StringStream(rawString: str)
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertNil(result.value)
        XCTAssertEqual(result.stream.current(), stream.current())
    }
    
    func testNoCodeLinesButCodeInliningEnd() throws {
        // Arrange
        
        let stub = StubRule<CodeInliningBodyLine?> { stream in
            return .init(value: nil, stream: stream)
        }
        
        let rule = CodeInliningRule(bodyLineRule: stub.erase())
        
        let str = "~{##}~"
        let stream = try StringStream(rawString: str)
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertNotNil(result.value)
        XCTAssertTrue(result.stream.isFinished())
        
        switch result.value! {
        case.codeInliningBody(let arr):
            XCTAssertTrue(arr.isEmpty)
        }
    }
    
    
    func testNoCodeLinesAndNoCodeInliningEnd() throws {
        // Arrange
        
        let stub = StubRule<CodeInliningBodyLine?> { stream in
            return .init(value: nil, stream: stream)
        }
        
        let rule = CodeInliningRule(bodyLineRule: stub.erase())
        
        let str = "~{#"
        let stream = try StringStream(rawString: str)
        
        // Act - Assert
        
        XCTAssertThrowsError(try rule.run(with: stream))
    }
    
    func testCodeLinesAndCodeInliningEndExist() throws {
        // Arrange
        
        let stub = StubRule<CodeInliningBodyLine?> { stream in
            var c = stream.copy()
            c.moveForward(on: 4) // because first element would by " " and o dont think that i have to handle it in stub
            return .init(value: .number(123), stream: c)
        }
        
        let rule = CodeInliningRule(bodyLineRule: stub.erase())
        
        let str = "~{# 113 #}~"
        let stream = try StringStream(rawString: str)
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertNotNil(result.value)
        XCTAssertTrue(result.stream.isFinished())
        
        switch result.value! {
        case.codeInliningBody(let arr):
            XCTAssertEqual(arr.count, 1)
            switch arr[0] {
            case.number(let num):
                XCTAssertEqual(num, 123)
            case .string(let str):
                XCTFail("Expected number but got string token \(str)")
            }
        }
    }
}
