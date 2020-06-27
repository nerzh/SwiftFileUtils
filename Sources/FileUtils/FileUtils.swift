import Foundation


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
}
