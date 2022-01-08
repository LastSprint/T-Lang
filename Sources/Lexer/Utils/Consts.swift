//
//  Consts.swift
//  
//
//  Created by Александр Кравченков on 06.01.2022.
//

import Foundation

/// Contains global constants
enum Consts {
    /// Set of number characters - 0,1,2,3,4,5,6,7,8,9
    static let numbersCharaterSet = Set<Character>("0123456789")
    
    /// Set of "letter" characters
    static let nameCharactersSet = Set<Character>("abcdefghijklmonpqrstuvwxyz".duplicateAndUppercased() + "_")
}
