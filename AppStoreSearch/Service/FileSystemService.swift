//
//  FileSystemService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/9/22.
//

import Foundation


struct FilesystemServiceError: Error {

    enum ErrorType {
        case fileDoesNotExist
        case failedToSaveJSONResponse
    }
    
    let code = ApplicationErrorType.fileSystemServiceErrorCode
    let type: ErrorType
    let text: String

}

let jsonFilename = "http_response.json"
let resourcesDirName = "Resources"
let queueName = "FileSystemServiceQueue"

struct FileSystemService {
    
    private static let queue = DispatchQueue(label: queueName, qos: .background)
    
    // pjh: write and forget
    static func saveJSONResponse(source: [String: Any]?, path: String?) {
        queue.async {
            guard let content: [String: Any] = source else { return }
            guard let _path = path else { return }
            
            let docsDir = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
            var filepathURL = docsDir[0].appendingPathComponent(_path)
            let resourcesURL = filepathURL.appendingPathComponent(resourcesDirName)
            do {
                try FileManager.default.createDirectory(at: filepathURL, withIntermediateDirectories: false)
                try FileManager.default.createDirectory(at: resourcesURL, withIntermediateDirectories: false)
                filepathURL = filepathURL.appendingPathComponent(jsonFilename)
                let json = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                try json.write(to: filepathURL)

            } catch {
                return
            }
        }
    }
}
