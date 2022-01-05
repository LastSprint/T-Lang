//
//  SymbolStream.swift
//
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

/// Interface for any thing which can read text date symbol by symbol
///
/// See Also: `StringStream`
public protocol SymbolStream {
    /// Return current symbol and then move pointer to the next one
    /// If text is finished before calling `pop` then will return nil
    mutating func pop() -> Character?
    /// Moves stream pointer back on `count` elements
    /// If count is bigger than size of the content then method will move pointer on max possible distance
    mutating func moveBack(on count: Int)
    /// Moves stream pointer forward on `count` elements
    /// If count is bigger than size of the content then method will move pointer on max possible distance
    mutating func moveForward(on count: Int)
    /// Returns current pointed symbol
    /// If text is finished then returns nill
    func current() -> Character?
    /// Return copy of this stream.
    /// So ypu can mutate the copy and this instance won't be changed
    func copy() -> Self
    /// Returns true if text was ended (all text was poped)
    func isFinished() -> Bool
}
