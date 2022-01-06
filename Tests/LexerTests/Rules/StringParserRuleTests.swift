//
//  StringParserRuleTests.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import XCTest

@testable import Lexer

// Test Cases:
// 1. String will be parsed
// 2. String with new line will throw error
// 3. String without end will throw error
// 4. String with \\n will be parsed (TODO)
// 5. String without start symbol wont be parsed
// 6. Empty string will be parsed
final class StringParserRuleTests: XCTestCase {
    func testSimpleStringWillBeParsed() throws {
        // Arrange
        
        let value = "value"
        let string = "\"\(value)\""
        let stream = try StringStream(rawString: string)
        let rule = StringParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.value, value)
        XCTAssertTrue(result.stream.isFinished())
    }
    
    func testStringWithNewWillThrowError() throws {
        // Arrange
    
        let string = """
"sdfsdf
sdf"
"""
        let stream = try StringStream(rawString: string)
        let rule = StringParserRule()
        
        // Act - Assert
        
        XCTAssertThrowsError(try rule.run(with: stream))
    }
    
    func testStringWithoutEndingWillThrowwError() throws {
        // Arrange
    
        let string = "\"asd"
        let stream = try StringStream(rawString: string)
        let rule = StringParserRule()
        
        // Act - Assert
        
        XCTAssertThrowsError(try rule.run(with: stream))
    }
    
    func testStringWuhtoutStartSymblWontBeParsed() throws {
        // Arrange
    
        let string = "sdfsdf\""
        let stream = try StringStream(rawString: string)
        let rule = StringParserRule()
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertNil(result.value)
        XCTAssertEqual(result.stream.current(), stream.current())
    }
    
    func testEmptyStringWillBeParsed() throws {
        // Arrange
    
        let string = "\"\""
        let stream = try StringStream(rawString: string)
        let rule = StringParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.value, "")
        XCTAssertTrue(result.stream.isFinished())
    }
}
