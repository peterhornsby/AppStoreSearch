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
let jsonQueueName = "jsonQueue"
let iconQueueName = "iconQueue"
let screenshotQueueName = "screenshotQueue"
struct FileSystemService {
    private static let jsonQueue = DispatchQueue(label: jsonQueueName, qos: .background)
    private static let iconQueue = DispatchQueue(label: iconQueueName, qos: .background)
    private static let screenshotQueue = DispatchQueue(label: screenshotQueueName, qos: .background)
    
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
    
    fileprivate func screenshotPath(appId: String, term: String, index: Int) -> URL {
        let resourcesURL = worker.resoursePath(with: appId, term: term)
        return resourcesURL.appendingPathComponent("screenshot_\(index).jpg")
    }
    
    
    // pjh: write and forget
    static func saveJSONResponse(source: [String: Any]?, appId: String, term: String) {
        jsonQueue.async {
            guard let content: [String: Any] = source else { return }
            do {
                let filepathURL = worker.resoursePath(with: appId, term: term).appendingPathComponent(jsonFilename)
                let json = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                try json.write(to: filepathURL)
            } catch {
                return
            }
        }
    }
    
    
    static func saveAppIcon(rawData: Data?, appId: UUID, term: String) {
        iconQueue.async {
            let filepathURL = worker.iconPath(appId: appId.uuidString, term: term)
            if let data = rawData {
                if let image = UIImage(data: data)?.jpegData(compressionQuality: 1) {
                    try? image.write(to: filepathURL)
                }
            }
        }
    }
    
    
    static func appIcon(for appId: UUID, term: String) -> UIImage? {
        let filepathURL = worker.iconPath(appId: appId.uuidString, term: term)
        return UIImage(contentsOfFile: filepathURL.path)
    }
    
    static func screenshotURLSFromJSONFile(for appId: String, term: String) -> [URL]? {
        let url = worker.resoursePath(with: appId, term: term).appendingPathComponent(jsonFilename)
        if let data = try? Data(contentsOf: url) {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // pjh: todo: check what device the app is running on and look for screenshots
                if let array = json["screenshotUrls"] as? [String] {
                    return array.compactMap { URL(string: $0)}
                }
            }
        }
        
        return nil
    }
    
    
    static func saveScreenshot(_ rawData: Data?, _ appId: UUID, _ term: String, _ index: Int) {
        screenshotQueue.async {
            let filepathURL = worker.screenshotPath(appId: appId.uuidString, term: term, index: index)
            if let data = rawData {
                if let image = UIImage(data: data)?.jpegData(compressionQuality: 1) {
                    try? image.write(to: filepathURL)
                    return
                }
            }
        }

    }
}


// pjh: internal worker - dettached from service interface
let worker = FileSystemService()
