//
//  StreamResult.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

/// Use to pass value read from stream and new stream with new pointer position
/// It will mean like "I have read `value` from stream you had passed. Now i'm returning you the `value` i've read and copy of stream you'd passed but with pointer shifted to the next symbol after `value` token
public struct StreamResult<Value, Stream> {
    public let value: Value
    public let stream: Stream
    
    public init(value: Value, stream: Stream) {
        self.value = value
        self.stream = stream
    }
}
