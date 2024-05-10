//
//  ReadFile.swift
//  
//
//  Created by Oleh Hudeichuk on 27.06.2020.
//

import Foundation

public extension FileUtils {

    class func readFile(_ url: URL, encoding: String.Encoding = .utf8) throws -> String {
        try String(contentsOf: url, encoding: encoding)
    }
    
    class func readFile(_ url: URL) throws -> Data {
        try Data(contentsOf: url)
    }

    class func readStringByLine(_ path: String, _ handler: (_ line: String) throws -> Void) throws {
        let file: FileReader = .init(filePath: path)
        try file.open()
        defer { file.close() }
        while let line: String = try file.readLine() {
            try handler(line)
        }
    }

    class func readStringByLine(_ url: URL, _ handler: (_ line: String) throws -> Void) throws {
        try readStringByLine(url.path, handler)
    }
    
    class func readFileByLine(_ url: URL, maxLength: Int = 4096, _ handler: (_ line: Data) throws -> Void) throws {
        try readFileByLine(url.path, maxLength: maxLength, handler)
    }
    
    class func readFileByLine(_ path: String, maxLength: Int = 4096, _ handler: (_ line: Data) throws -> Void) throws {
        let file: FileReader = .init(filePath: path)
        try file.open()
        defer { file.close() }
        while let line: Data = try file.readLine(maxLength: maxLength) {
            try handler(line)
        }
    }

    class func readStringByLineWithBool(_ path: String, _ handler: (_ line: String) throws -> Bool) throws {
        let file: FileReader = .init(filePath: path)
        try file.open()
        defer { file.close() }
        while let line: String = try file.readLine() {
            if try !handler(line) { break }
        }
    }

    class func readStringByLineWithBool(_ url: URL, _ handler: (_ line: String) throws -> Bool) throws {
        try readStringByLineWithBool(url.path, handler)
    }
}
