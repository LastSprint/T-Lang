//
//  FuncCallArgsRuleTests.swift
//  
//
//  Created by Александр Кравченков on 07.01.2022.
//

import Foundation
import XCTest

@testable import Lexer


// Test Cases:
// 1. Empty args will return empty array
// 2. Single arg will be parsed
// 3. Two args will be parsed
// 4. Extra coma won't be parsed
final class FuncCallArgsRuleTests: XCTestCase {
    
    func testEmptyArgsWillReturnEmptyArray() throws {
        // Arrange
        
        let stream = try StringStream(rawString: ")")
        let rule = FuncCallArgsRule(expressionRule: StubRule(runCommand: { .init(value: nil, stream: $0) }).erase())
        
        // Act
        
        let res = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertTrue(res.value.isEmpty)
        XCTAssertEqual(res.stream.current(), ")")
    }
    
    func testSingleArgWillBeParsed() throws {
        // Arrange
        
        let stream = try StringStream(rawString: "arg1)")
        let rule = FuncCallArgsRule(expressionRule: StubRule(runCommand: {
            .init(value: nil, stream: $0)
        }).erase())
        
        // Act
        
        let res = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(res.value.count, 1)
        XCTAssertEqual(res.stream.current(), ")")
        
        guard ExpressionNode.anyName(let name) = res.value else {
            XCTFail("Result should be expression not but got \(res)")
        }
    }
}
