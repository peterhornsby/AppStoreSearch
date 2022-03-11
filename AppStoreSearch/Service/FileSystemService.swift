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
let appIconFilename = "app_icon.jpg"
let resourcesDirName = "Resources"
let queueName = "FileSystemServiceQueue"



struct FileSystemService {
    
    private static let queue = DispatchQueue(label: queueName, qos: .background)
    
    
    fileprivate func docsDirURL() -> URL {
        let docsDir = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
        return docsDir[0]
    }
    
    fileprivate func resoursePath(with appId: String, term: String) -> URL {
        let docsDir = worker.docsDirURL()
        let termURL = docsDir.appendingPathComponent(term, isDirectory: true)
        let filepathURL = termURL.appendingPathComponent(appId, isDirectory: true)
        let resourcesURL = filepathURL.appendingPathComponent(resourcesDirName)
        do {
//            try FileManager.default.createDirectory(at: termURL, withIntermediateDirectories: false)
//            try FileManager.default.createDirectory(at: filepathURL, withIntermediateDirectories: false)
            try FileManager.default.createDirectory(at: resourcesURL, withIntermediateDirectories: true)
        } catch {
            return resourcesURL
        }
        
        
        
        return resourcesURL
    }
    
    fileprivate func iconPath(appId: String, term: String) -> URL {
        let resourcesURL = worker.resoursePath(with: appId, term: term)
        return resourcesURL.appendingPathComponent(appIconFilename)
    }
    
    
    // pjh: write and forget
    static func saveJSONResponse(source: [String: Any]?, appId: String, term: String) {
        queue.async {
            guard let content: [String: Any] = source else { return }
            print("saveJSONResponse: \(term) << search item")
//            let docsDir = worker.docsDirURL()
//            var filepathURL = docsDir.appendingPathComponent(appId)
//            let resourcesURL = worker.resoursePath(with: appId, term: term)
            do {
                let filepathURL = worker.resoursePath(with: appId, term: term).appendingPathComponent(jsonFilename)
                let json = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                try json.write(to: filepathURL)

            } catch {
                return
            }
        }
    }
    
    
    static func saveAppIcon(rawData: Data?, appId: UUID, term: String) -> Bool {
        let filepathURL = worker.iconPath(appId: appId.uuidString, term: term)
        if let data = rawData {
            if let image = UIImage(data: data)?.jpegData(compressionQuality: 1) {
                try? image.write(to: filepathURL)
                return true
            }
        }

        return false
    }
    
    
    static func appIcon(for appId: UUID, term: String) -> UIImage? {
        let docsDir = worker.docsDirURL()
        var filepathURL = worker.iconPath(appId: appId.uuidString, term: term)
        return UIImage(contentsOfFile: filepathURL.path)
    }
}


let worker = FileSystemService()
