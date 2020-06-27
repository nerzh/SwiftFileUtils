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

    class func readFileByLine(_ url: URL, _ handler: (_ line: String) -> Void) throws {
        let file: FileReader = .init(fileURL: url)
        try file.open()
        defer { file.close() }
        while let line: String = try file.readLine() {
            handler(line)
        }
    }

    class func readFileByLine(_ path: String, _ handler: (_ line: String) -> Void) throws {
        let file: FileReader = .init(filePath: path)
        try file.open()
        defer { file.close() }
        while let line: String = try file.readLine() {
            handler(line)
        }
    }
}
