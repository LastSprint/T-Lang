//
//  FindTokenTests.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import XCTest

@testable import Lexer

// 1. String without token will return nil
// 2. Will be returned the biggest token
// 3. If biggest token isnt appropriate then lower token will be returned
final class FindTokenTests: XCTestCase {
    
    func testStringWithoutTokens() throws {
        // Arrange
        
        let tokens = ["a", "b", "c"]
        let str = "fghj"
        
        // Act
        
        let result = try ConstantsTokens.findToken(tokens: tokens, stream: try StringStream(rawString: str), index: 0)
        
        // Assert
        
        XCTAssertNil(result.value)
        XCTAssertEqual(result.stream.currentIndex, str.startIndex)
    }
    
    func testBiggestToken() throws {
        // Arrange
        
        let tokens = ["a", "ab", "abc", "e", "abce"]
        let str = "abceasa"
        
        // Act
        
        let result = try ConstantsTokens.findToken(tokens: tokens, stream: try StringStream(rawString: str), index: 0)
        
        // Assert
        
        XCTAssertNotNil(result.value)
        XCTAssertEqual(result.value, tokens.last)
        XCTAssertEqual(result.stream.currentIndex, str.index(str.startIndex, offsetBy: 4))
    }
    
    func testBiggestTokenNotOk() throws {
        // Arrange
        
        let tokens = ["a", "ab", "abc", "e", "abce"]
        let str = "abcfasa"
        
        // Act
        
        let result = try ConstantsTokens.findToken(tokens: tokens, stream: try StringStream(rawString: str), index: 0)
        
        // Assert
        
        XCTAssertNotNil(result.value)
        XCTAssertEqual(result.value, tokens[2])
        XCTAssertEqual(result.stream.currentIndex, str.index(str.startIndex, offsetBy: 3))
    }
}
