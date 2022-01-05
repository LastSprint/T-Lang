//
//  StringStream.swift
//
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

/// Converts string to stream from which consumers can read cahracter by character
/// Makes it possible to hide file reading implementation
///
/// Implements Copy On Write for intetrnal string so it wont be copied each time you reassign value
public struct StringStream {

    private let fileContent: CopyOnWriteBox<String>
    private let filePath: CopyOnWriteBox<String>
    
    private var currentIndex: String.Index
    
    init(pathToFile: String) throws {
        self.fileContent = .init(try String.init(contentsOfFile: pathToFile))
        self.currentIndex = fileContent.value.startIndex
        self.filePath = .init(pathToFile)
    }
    
    init(rawString: String) throws {
        self.fileContent = .init(rawString)
        self.currentIndex = fileContent.value.startIndex
        self.filePath = .init("testfile")
    }
}

extension StringStream: SymbolStream {
    mutating public func pop() -> Character? {
        
        if self.isFinished() {
            return nil
        }
        
        let result = self.current()
        self.currentIndex = self.fileContent.value.index(after: self.currentIndex)
        return result
    }
    
    public func current() -> Character? {
        
        if self.isFinished() {
            return nil
        }
        
        return self.fileContent.value[self.currentIndex]
    }
    
    public func copy() -> StringStream {
        return self
    }
    
    public func isFinished() -> Bool {
        return self.currentIndex == self.fileContent.value.endIndex
    }
}

extension StringStream: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        do {
            let (line, lineNumber, characterNumber) = try self.fileContent.value.getLineAndMeta(currentIndex: self.currentIndex)
            
            var result = "File: \(self.filePath.value)\n"
            let lineStr = "\(lineNumber): \(line)"
            let pointerPosition = (lineStr.count - line.count) + characterNumber
            result += String(repeating: " ", count: pointerPosition - 2) + "↓" + "\n"
            result += lineStr
            return result
        } catch {
            return "Error occured in debug print for file \(self.filePath.value): \(error.localizedDescription)"
        }
    }
}

