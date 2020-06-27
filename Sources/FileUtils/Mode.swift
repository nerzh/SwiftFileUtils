//
//  Mode.swift
//  
//
//  Created by Oleh Hudeichuk on 26.06.2020.
//

import Foundation

public extension FileUtils {
    
    struct Mode: OptionSet {

        public var rawValue: Int
        public typealias RawValue = Int
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

//        public static var rewrite = Mode(rawValue: 1)
        public static var append = Mode(rawValue: 2)
        public static var clear = Mode(rawValue: 3)
        public static var createFile = Mode(rawValue: 4)
    }
}
