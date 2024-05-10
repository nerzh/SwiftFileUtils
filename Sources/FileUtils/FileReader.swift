//
//  FileReader.swift
//  
//
//  Created by Oleh Hudeichuk on 26.06.2020.
//

import Foundation

class FileReader {

    let fileURL: URL
    private var file: UnsafeMutablePointer<FILE>? = nil

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    init(filePath: String) {
        guard let fileURL: URL = URL(string: filePath) else { fatalError("Can't convert path \(filePath) to URL") }
        self.fileURL = fileURL
    }

    deinit {
        if self.file != nil { fatalError("Please, close file descriptor.") }
    }

    func open() throws {
        guard let descriptor = fopen(fileURL.path, "r") else {
            throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno), userInfo: nil)
        }
        self.file = descriptor
    }

    func close() {
        if let descriptor = self.file {
            self.file = nil
            let success: Bool = fclose(descriptor) == 0
            assert(success)
        }
    }

    func readLine(maxLength: Int = 4096) throws -> String? {
        guard let descriptor = self.file else {
            throw NSError(domain: NSPOSIXErrorDomain, code: Int(EBADF), userInfo: nil)
        }
        var buffer = Array<Int8>.init(repeating: 0, count: maxLength)
        guard fgets(&buffer, Int32(maxLength), descriptor) != nil else {
            if feof(descriptor) != 0 {
                return nil
            } else {
                throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno), userInfo: nil)
            }
        }
        
        return String(cString: buffer)
    }
    
    func readLine(maxLength: Int = 4096) throws -> Data? {
        guard let descriptor = self.file else {
            throw NSError(domain: NSPOSIXErrorDomain, code: Int(EBADF), userInfo: nil)
        }
        var buffer = Array<Int8>.init(repeating: 0, count: maxLength)
        guard fgets(&buffer, Int32(maxLength), descriptor) != nil else {
            if feof(descriptor) != 0 {
                return nil
            } else {
                throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno), userInfo: nil)
            }
        }

        let newBuffer: Array<UInt8> = unsafeBitCast(buffer, to: Array<UInt8>.self)

        return Data(newBuffer)
    }
    
//    func readLine(maxLength: Int = 4096) throws -> Data? {
//        if let stream: InputStream = InputStream(fileAtPath: fileURL.path) {
//            var buf: [UInt8] = [UInt8](repeating: 0, count: 16)
//            stream.open()
//            while true {
//                let len = stream.read(&buf, maxLength: buf.count)
//                print("len \(len)")
////                c += len
////                for i in 0..<len {
////                    print(String(format:"%02x ", buf[i]), terminator: "")
////                }
//                if len < buf.count {
//                    break
//                }
//            }
//            stream.close()
//        }
//    }
}
