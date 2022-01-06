//
//  CodeBodyRuleIntegrationTests.swift
//
//
//  Created by Александр Кравченков on 06.01.2022.
//

import Foundation
import XCTest

@testable import Lexer

// Test Cases:
//
// 1. Template without iniling ✅
// 2. Template with one iniling ✅
// 3. Template with several inlinings ✅
// 4. Empty template will return nil ✅
// 5. Inlining without end will throw error ✅
// 6. Escaped inlining won't be parsed as inlining ✅
final class CodeBodyRuleIntegrationTests: XCTestCase {

    var root = EntryPointRule(
        next: ReadTemplateRule(
            codeInliningRule: CodeInliningRule(
                bodyLineRule: CodeInliningExpressionRule(
                    numberParserRule: NumberParserRule().erase(),
                    stringParserRule: StringParserRule().erase()
                ).erase()
            ).erase(),
        readCharRule: ReadCharRule().erase()
    ).erase())
    
    func testTemplateWthoitInligning() throws {
        // Arrange
        
        let expected = "[FBN[CHR[1]], FBN[CHR[ ]], FBN[CHR[2]], FBN[CHR[ ]], FBN[CHR[3]], FBN[CHR[ ]]]"
        let stream = try StringStream(rawString: "1 2 3 ")

        // Act
        
        let result = try root.run(with: stream)

        // Assert
        
        XCTAssertFalse(result.value.isEmpty)
        XCTAssertEqual(result.value.debugDescription, expected)
    }
    
    func testTemplateWithOneInlining() throws {
        // Arrange
    
        let stream = try StringStream(rawString: "1@{ 1 } ")
        let expected = "[FBN[CHR[1]], FBN[CIB[NM[1.0]]], FBN[CHR[ ]]]"
        
        // Act
        
        let result = try root.run(with: stream)

        // Assert
        
        XCTAssertFalse(result.value.isEmpty)
        XCTAssertEqual(result.value.debugDescription, expected)
    }
    
    func testTemplateWithSeveralInlining() throws {
        // Arrange
    
        let fileContent = """
1 @{2}
@{"sdf"}
"""
        let stream = try StringStream(rawString: fileContent)
        let expected = "[FBN[CHR[1]], FBN[CHR[ ]], FBN[CIB[NM[2.0]]], FBN[CHR[\n]], FBN[CIB[STR[sdf]]]]"
        
        // Act
        
        let result = try root.run(with: stream)

        // Assert
        
        XCTAssertFalse(result.value.isEmpty)
        XCTAssertEqual(result.value.debugDescription, expected)
    }
    
    func testEmptyTemplateWillReturnNil() throws {
        // Arrange

        let stream = try StringStream(rawString: "")
        
        // Act
        
        let result = try root.run(with: stream)

        // Assert
        
        XCTAssertTrue(result.value.isEmpty)
    }
    
    func testInliningWithoutEndWillThrowError() throws {
        // Arrange
    
        let fileContent = """
1 @{2}
@{"sdf"
"""
        let stream = try StringStream(rawString: fileContent)
        
        // Act - Assert
        
        XCTAssertThrowsError(try root.run(with: stream))
    }
    
    func testEscapedInliningWontBeParsedAsInlining() throws {
        // Arrange
    
        let fileContent = """
1\\@{2}
@{"sdf"}
"""
        let stream = try StringStream(rawString: fileContent)
        let expected = "[FBN[CHR[1]], FBN[CHR[@]], FBN[CHR[{]], FBN[CHR[2]], FBN[CHR[}]], FBN[CHR[\n]], FBN[CIB[STR[sdf]]]]"
        
        // Act
        
        let result = try root.run(with: stream)

        // Assert
        
        XCTAssertFalse(result.value.isEmpty)
        XCTAssertEqual(result.value.debugDescription, expected)
    }
}
