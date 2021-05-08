import Foundation
import SwiftRegularExpression

public class FileUtils {}


public extension FileUtils {
    
    class func clearFile(_ url: URL?) {
        clearFile(url?.path)
    }
    
    class func clearFile(_ path: String?) {
        guard let path = path else { return }
        do {
            try "".write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
        } catch {
            fatalError("CLEAR FILE: Can't write to file \(path)")
        }
    }
    
    class func createFile(_ url: URL?) {
        createFile(url?.path)
    }
    
    class func deleteFileOrFolder(_ url: URL?) {
        do {
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: url?.path ?? "") {
                try fileManager.removeItem(atPath: url!.path)
            } else {
                fatalError("File does not exist")
            }
        } catch {
            fatalError("An error took place: \(error.localizedDescription)")
        }
    }
    
    class func createFile(_ path: String?) {
        guard let path = path else { return }
        FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
    }
    
    class func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL] {
        var fileURLs: [URL] = .init()
        
        if let documentsURL = FileManager.default.urls(for: directory, in: .userDomainMask).first {
            do {
                fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: skipsHiddenFiles ? [.skipsHiddenFiles] : [] )
            } catch {}
        }
        
        return fileURLs
    }
    
    class func urls(for directory: String, skipsHiddenFiles: Bool = true ) -> [URL] {
        guard let documentsURL = URL(string: directory) else { return [] }
        return urls(for: documentsURL, skipsHiddenFiles: skipsHiddenFiles)
    }
    
    class func urls(for directory: URL, skipsHiddenFiles: Bool = true ) -> [URL] {
        do {
            return try FileManager.default.contentsOfDirectory(at: directory,
                                                               includingPropertiesForKeys: [],
                                                               options: skipsHiddenFiles ? [.skipsHiddenFiles] : [] )
        } catch {
            return []
        }
    }
    
    class func readDirectory(for directory: URL, skipsHiddenFiles: Bool = true ) -> [URL] {
        urls(for: directory, skipsHiddenFiles: skipsHiddenFiles)
    }
    
    class func readDirectory(for directory: String, skipsHiddenFiles: Bool = true ) -> [URL] {
        urls(for: directory, skipsHiddenFiles: skipsHiddenFiles)
    }
    
    class func isDirectory(_ url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    }
    
    class func isDirectory(_ path: String) -> Bool {
        guard let url = URL(string: path) else { fatalError("\(path) - can not convert to URL") }
        return isDirectory(url)
    }
    
    class func isFile(_ url: URL) -> Bool {
        !isDirectory(url)
    }
    
    class func isFile(_ path: String) -> Bool {
        guard let url = URL(string: path) else { fatalError("\(path) - can not convert to URL") }
        return isFile(url)
    }
    
    class func fileExist(_ url: URL) -> Bool {
        fileExist(url.path)
    }
    
    class func fileExist(_ path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    class func directoryExist(_ url: URL) -> Bool {
        directoryExist(url.path)
    }
    
    class func directoryExist(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    class func absolutePath(_ path: String) throws -> String {
        let pointer: UnsafeMutablePointer<Int8>? = realpath(path, nil)
        guard
            let cStringPointer: UnsafeMutablePointer<Int8> = pointer
        else { throw fatalError("unknown error for path: \(path)\nPlease, check your path.\n") }
        defer { free(cStringPointer) }
        
        return String(cString: cStringPointer)
    }
    
    class func absolutePath(_ url: URL) throws -> String {
        try absolutePath(url.path)
    }
    
    class func urlEncode(_ string: String) -> String {
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: ".-_")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
    
    class func makeRelativePath(from projectPath: String, to filePath: String) -> String? {
        guard let realProjectPath: String = try? absolutePath(projectPath) else { return nil }
        return filePath.replace(realProjectPath, "")
    }
    
    class func readDirectory(path: String, _ handler: (URL) -> Void) {
        urls(for: urlEncode(path)).forEach { handler($0) }
    }
    
    class func readDirectory(path: URL, _ handler: (URL) -> Void) {
        readDirectory(path: path.path, handler)
    }
    
    class func recursiveReadDirectory(path: String, _ handler: (_ folder: String, _ file: URL) -> Void) {
        readDirectory(path: path) { (url) in
            if isDirectory(url) {
                recursiveReadDirectory(path: url.path, handler)
            } else {
                handler(path, url)
            }
        }
    }
    
    class func recursiveReadDirectory(path: URL, _ handler: (_ folder: URL, _ file: URL) -> Void) {
        readDirectory(path: path) { (url) in
            if isDirectory(url) {
                recursiveReadDirectory(path: url, handler)
            } else {
                handler(path, url)
            }
        }
    }
    
}
