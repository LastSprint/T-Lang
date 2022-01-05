//
//  GetLineAndMetaTests.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import XCTest

@testable import Lexer

// Test Cases:
// 1. Correct world will be chosen if pointer in the beginning of the world
// 2. Correct world will be chosen if pointer in the middle of the world
// 3. Correct world will be chosen if pointer in the end of the world
// 4. Line number will be correct
// 5. Char number will be correct
//
// FYI: To get global index if character in `text` use any text editor which can show selected line and column numbers and can show how many characters you have selected  (with \n symbol)
final class GetLineAndMetaTests: XCTestCase {
    
    let text = """
In computing, a compiler is a computer program that translates computer code written in one programming language (the source language)
into another language (the target language).
The name "compiler" is primarily used for programs that translate source code from a high-level programming language
to a lower level language (e.g. assembly language, object code, or machine code) to create an executable program.[1][2]: p1

There are many different types of compilers which produce output in different useful forms.
A cross-compiler produces code for a different CPU or operating system than the one on which the cross-compiler itself runs.
A bootstrap compiler is often a temporary compiler, used for compiling a more permanent or better optimised compiler for a language.

Related software include, a program that translates from a low-level language to a higher level one is a decompiler ;
a program that translates between high-level languages, usually called a source-to-source compiler or transpiler.
A language rewriter is usually a program that translates the form of expressions without a change of language.
A compiler-compiler is a compiler that produces a compiler (or part of one), often in a generic and reusable way so as to be able to produce many differing compilers.

A compiler is likely to perform some or all of the following operations, often called phases:
    - preprocessing,
    - lexical analysis,
    - parsing,
    - semantic analysis (syntax-directed translation),
    - conversion of input programs to an intermediate representation,
    - code optimization and code generation.
Compilers generally implement these phases as modular components, promoting efficient design and correctness of transformations of source input to target output.
Program faults caused by incorrect compiler behavior can be very difficult to track down and work around; therefore,
compiler implementers invest significant effort to ensure compiler correctness.[3]

Compilers are not the only language processor used to transform source programs.
An interpreter is computer software that transforms and then executes the indicated operations.
[2]: p2  The translation process influences the design of computer languages, which leads to a preference of compilation or interpretation.
In theory, a programming language can have both a compiler and an interpreter.
In practice, programming languages tend to be associated with just one (a compiler or an interpreter).
"""
    
    func testPointerInTheBeginning() throws {
        // Arrange
    
        let indexOfCharacter = 1638
        let stringIndex = text.index(text.startIndex, offsetBy: indexOfCharacter)
        
        let expectedLine = "Compilers generally implement these phases as modular components, promoting efficient design and correctness of transformations of source input to target output."
        // if we select string from the beginning to s (in trnslate) we will get 51 selected characters. It means that we have to expect 50 index counting from 0)
        let expectedCharNumer = 30
        let expectedLineNumber = 22
        print(text[stringIndex])
        // Act
        
        let result = try text.getLineAndMeta(currentIndex: stringIndex)
        
        // Assert
        
        XCTAssertEqual(result.line, expectedLine)
        XCTAssertEqual(result.lineNumber, expectedLineNumber)
        XCTAssertEqual(result.characterNumber, expectedCharNumer)
        XCTAssertEqual(text[stringIndex], result.line[result.line.index(result.line.startIndex, offsetBy: result.characterNumber)])
    }
    
    func testPointerInTheMiddle() throws {
        // Arrange
    
        let indexOfCharacter = 940
        let stringIndex = text.index(text.startIndex, offsetBy: indexOfCharacter)
        
        let expectedLine = "a program that translates between high-level languages, usually called a source-to-source compiler or transpiler."
        
        let expectedCharNumer = 49
        let expectedLineNumber = 11
        print(text[stringIndex])
        // Act
        
        let result = try text.getLineAndMeta(currentIndex: stringIndex)
        
        // Assert
        
        XCTAssertEqual(result.line, expectedLine)
        XCTAssertEqual(result.lineNumber, expectedLineNumber)
        XCTAssertEqual(result.characterNumber, expectedCharNumer)
        XCTAssertEqual(text[stringIndex], result.line[result.line.index(result.line.startIndex, offsetBy: result.characterNumber)])
    }
    
    func testPointerInTheEnd() throws {
        // Arrange
    
        let indexOfCharacter = 2468
        let stringIndex = text.index(text.startIndex, offsetBy: indexOfCharacter)
        
        let expectedLine = "In practice, programming languages tend to be associated with just one (a compiler or an interpreter)."
        
        let expectedCharNumer = 101
        let expectedLineNumber = 30
        print(text[stringIndex])
        // Act
        
        let result = try text.getLineAndMeta(currentIndex: stringIndex)
        
        // Assert
        
        XCTAssertEqual(result.line, expectedLine)
        XCTAssertEqual(result.lineNumber, expectedLineNumber)
        XCTAssertEqual(result.characterNumber, expectedCharNumer)
        XCTAssertEqual(text[stringIndex], result.line[result.line.index(result.line.startIndex, offsetBy: result.characterNumber)])
    }
    
    func testKek() {
        var str: SymbolStream = try! StringStream(rawString: text)
        for _ in 0...940 {
            str.pop()
        }
        
        print(str)
    }
}
