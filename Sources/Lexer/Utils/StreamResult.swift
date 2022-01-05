//
//  StreamResult.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

struct StreamResult<Value, Stream> {
    let value: Value
    let stream: Stream
}
