//
//  WriteFile.swift
//  
//
//  Created by Oleh Hudeichuk on 27.06.2020.
//

import Foundation

public extension FileUtils {

    class func writeFile(to: URL?,
                         _ data: Data?,
                         _ mode: FileUtils.Mode = [.clear]
    ) throws {
        if data == nil || to == nil { return }
        if mode.contains(.createFile) && !fileExist(to!) {
            createFile(to)
        }
        if mode.contains(.clear) { clearFile(to) }
        let fileHandle: FileHandle = try FileHandle(forWritingTo: to!)
        if mode.contains(.append) {
            fileHandle.seekToEndOfFile()
        }
        fileHandle.write(data!)
        fileHandle.closeFile()
    }

    class func writeFile(to path: String?,
                         _ data: Data?,
                         _ mode: FileUtils.Mode = [.clear]
    ) {
        if data == nil || path == nil { return }
        if mode.contains(.createFile) && !fileExist(path!) {
            createFile(path)
        }
        if mode.contains(.clear) { clearFile(path) }
        let fileHandle: FileHandle? = FileHandle(forWritingAtPath: path!)
        if mode.contains(.append) {
            fileHandle?.seekToEndOfFile()
        }
        fileHandle?.write(data!)
        fileHandle?.closeFile()
    }

    class func writeFile(to path: String?,
                         _ text: String?,
                         _ encoding: String.Encoding = .utf8,
                         _ mode: FileUtils.Mode = [.clear]
    ) {
        writeFile(to: path, text?.data(using: encoding))
    }

    class func writeFile(to: URL?,
                         _ text: String?,
                         _ encoding: String.Encoding = .utf8,
                         _ mode: FileUtils.Mode = [.clear]
    ) throws {
        try writeFile(to: to, text?.data(using: encoding))
    }

    class func writeFilePosix(to: String,
                        _ text: String,
                        _ encoding: String.Encoding = .utf8,
                        _ oflag: Int32 = O_TRUNC | O_WRONLY | O_CREAT,
                        _ mode: mode_t = 0o755
    ) {
        let fileDescriptor: Int32 = open(to, oflag, mode)
        if fileDescriptor < 0 {
            perror("could not open \(to)")
        } else {
            guard let size: Int = text.data(using: encoding)?.count else { return }
            write(fileDescriptor, text, size)
            close(fileDescriptor)
        }
    }

    class func writeFilePosix(to: String,
                              _ data: Data?,
                              _ oflag: Int32 = O_TRUNC | O_WRONLY | O_CREAT,
                              _ mode: mode_t = 0o755
    ) {
        let fileDescriptor: Int32 = open(to, oflag, mode)
        if fileDescriptor < 0 {
            perror("could not open \(to)")
        } else {
            guard let size: Int = data?.count else { return }
            var data = data
            withUnsafePointer(to: &data!) { (pointer: UnsafePointer<Data>) -> Void in
                write(fileDescriptor, pointer, size)
            }
            close(fileDescriptor)
        }
    }
}
