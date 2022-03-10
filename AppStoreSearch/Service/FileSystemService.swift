//
//  FileSystemService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/9/22.
//

import Foundation
import UIKit

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
    
    
    static func saveAppIcon(image: UIImage?, appId: UUID) -> Bool {
        guard let icon = image else { return false }
        
        let docsDir = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
        var filepathURL = docsDir[0].appendingPathComponent(appId.uuidString)
        filepathURL = filepathURL.appendingPathComponent(resourcesDirName)
        filepathURL = filepathURL.appendingPathComponent("app_icon.jpg")
        
        if let data = image?.jpegData(compressionQuality: 1) {
            try? data.write(to: filepathURL)
            return true
        }
        
        return false
    }
    
    
    static func appIcon(for appId: UUID) -> UIImage? {
        let docsDir = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
        var filepathURL = docsDir[0].appendingPathComponent(appId.uuidString)
        filepathURL = filepathURL.appendingPathComponent(resourcesDirName)
        filepathURL = filepathURL.appendingPathComponent("app_icon.jpg")
        
        return UIImage(contentsOfFile: filepathURL.path)
    }
}
