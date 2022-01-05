//
//  NumberParserRuleTests.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import XCTest

@testable import Lexer

// Test Cases:
// 1. Number parsed
// 2. Number with string literal will be parsed
// 3. Number with dot will be parsed
// 4. Number with two dots will be partially parsed (number before dot)
// 5. Number which is started from string literal won't be parsed
// 6. Number which is started from dot wont be parsed
// 7. Number which is finished with dot will be partially parsed
final class NumberParserRuleTests: XCTestCase {
    
    func testSimpleNumberWillBwParsed() throws {
        
        // Arrange
        
        let number = 123
        let string = " \(number)"
        let stream = try StringStream(rawString: string)
        let rule = NumberParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.value, Double(number))
        XCTAssertTrue(result.stream.isFinished())
    }
    
    func testNumberWithStringLiteralWillBeParsed() throws {
        
        // Arrange
        
        let number = 123
        let string = " \(number)asd"
        let stream = try StringStream(rawString: string)
        let rule = NumberParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.value, Double(number))
        XCTAssertEqual(result.stream.current(), "a")
    }
    
    func testNumberWithDot() throws {
        
        // Arrange
        
        let number = 123.123
        let string = " \(number)"
        let stream = try StringStream(rawString: string)
        let rule = NumberParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.value, number)
        XCTAssertTrue(result.stream.isFinished())
    }
    
    func testNumberWithTwoWillBePrtiallyParsed() throws {
        
        // Arrange
    
        let string = " 12.12.12"
        let stream = try StringStream(rawString: string)
        let rule = NumberParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.value, 12.12)
        XCTAssertEqual(result.stream.current(), ".")
    }
    
    func testNumberWhichIsStratedFromStringWontBeParsed() throws {
        
        // Arrange
    
        let string = " sdsfd123"
        let stream = try StringStream(rawString: string)
        let rule = NumberParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertNil(result.value)
        XCTAssertEqual(result.stream.current(), stream.current())
    }
    
    func testNumberWhichIsStratedFromDotWontBeParsed() throws {
        
        // Arrange
        
        let string = ".123"
        let stream = try StringStream(rawString: string)
        let rule = NumberParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertNil(result.value)
        XCTAssertEqual(result.stream.current(), stream.current())
    }
    
    func testNumberWhichIsFinishedWithDotWillBePartiallyParsed() throws {
        
        // Arrange
        
        let number = 123
        let string = "\(number)."
        let stream = try StringStream(rawString: string)
        let rule = NumberParserRule()
        
        // Act
        
        let result = try rule.run(with: stream)
        
        // Assert
        
        XCTAssertEqual(result.value, Double(number))
        XCTAssertEqual(result.stream.current(), ".")
    }
}
