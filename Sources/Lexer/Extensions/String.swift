//
//  File.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation
import Common

extension String {
    public func getLineAndMeta(currentIndex: String.Index) throws -> (line: String, lineNumber: Int, characterNumber: Int) {
    
        let distance = self.distance(from: self.startIndex, to: currentIndex)
        // distance returns index of element in string.
        // for example if we have string 01234 and we call distance(from: starIndex, to: indexOf4) then we will get 4 as distance.
        // so distance conted from zero.
        //
        // Example:
        /// ```Swift
        /// var str = "0123\n4567\n"
        /// var in4 = str.firstIndex(of: "4")!
        /// let dist = str.distance(from: str.startIndex, to: in4)
        /// let distance = self.distance(from: self.startIndex, to: currentIndex)
        /// print(dist) // -> 5
        /// print(str.count) // -> 10
        /// print(str[in4]) // -> 4
        /// ```
        // so then to tranform global character index to local (in line) correctly firsty we have to add 1 to distance.
        // Because we work with line counts (and we add +1 to each line count) we can chose wrong line.
        // Lets look at out example - we have 0123\n4567\n -> line 1: 0123 and line 2: 456
        // Lets find correct line for character `4`
        // As distance is 5 then we just do: 5 -= 4 + 1 => 0
        // that was happened because we substracted count (starts counting from 1) from distance (counting from 0)
        // and our distance is global for string. Thats why we add +1 only once
        var currentLine: String?
        var currentCounter = distance + 1
        var lineNumber = 0
        
        self.enumerateLines { line, stop in
            guard currentCounter > 0 else {
                stop = true
                return
            }
            
            currentLine = line
            // we add +1 because `line` doesn't contain `\n` character
            currentCounter -= line.count + 1
            lineNumber += 1
        }
        
        guard let line = currentLine else {
            throw CommonError(message: "Can't get line with global offset \(distance)")
        }
        
        return (line, lineNumber, line.count + currentCounter)
    }
}
