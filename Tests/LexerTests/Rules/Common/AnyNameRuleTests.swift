//
//  AnyNameRuleTests.swift
//  
//
//  Created by Александр Кравченков on 07.01.2022.
//

import Foundation
import XCTest

@testable import Lexer


// Test Cases:
// 1. String started from number won't be parsed
// 2. String ended with number will be partially parsed
// 3. String with underscore will be parsed
// 4. String with other symbols will be partially parsed
// 5. String only from letters will be parsed
final class AnyNameRuleTests: XCTestCase {
    
    func testStringStartedFromNumberWontBeParsed() throws {
        // Arrange
        
        let stream = try StringStream(rawString: "1asd")
        let rule = AnyNameRule()
        
        // Act
        
        let res = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertNil(res.value)
        XCTAssertEqual(res.stream.current(), stream.current())
    }
    
    func testStringEndedWithNumberWillBeParsed() throws {
        // Arrange
        
        let str = "asd1"
        let stream = try StringStream(rawString: str)
        let rule = AnyNameRule()
        
        // Act
        
        let res = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(res.value, str)
        XCTAssertTrue(res.stream.isFinished())
    }
    
    func testStringWithUnderscoreWillBeParsed() throws {
        // Arrange
        
        let str = "_a_s_d_"
        let stream = try StringStream(rawString: str)
        let rule = AnyNameRule()
        
        // Act
        
        let res = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(res.value, str)
        XCTAssertTrue(res.stream.isFinished())
    }
    
    func testStringWithOtherSymbolsWontBeParsed() throws {
        // Arrange
        
        let stream = try StringStream(rawString: "as-d")
        let rule = AnyNameRule()
        
        // Act
        
        let res = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(res.value, "as")
        XCTAssertFalse(res.stream.isFinished())
    }
    
    func testStringOnlyWithLettersWillBeParsed() throws {
        // Arrange
        
        let str = "asd"
        let stream = try StringStream(rawString: str)
        let rule = AnyNameRule()
        
        // Act
        
        let res = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(res.value, str)
        XCTAssertTrue(res.stream.isFinished())
    }
    
}
