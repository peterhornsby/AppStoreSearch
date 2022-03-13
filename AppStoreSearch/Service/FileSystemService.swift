//
//  FileSystemService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/9/22.
//

import Foundation
import UIKit
import os.log

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
    
    fileprivate func resoursePath(with appId: Int64) -> URL {
        let docsDir = worker.docsDirURL()
        let appsDir = docsDir.appendingPathComponent("Apps", isDirectory: true)
        let filepathURL = appsDir.appendingPathComponent(String(appId), isDirectory: true)
        let resourcesURL = filepathURL.appendingPathComponent(resourcesDirName)
        do {
            try FileManager.default.createDirectory(at: resourcesURL, withIntermediateDirectories: true)
        } catch {
            return resourcesURL
        }

        return resourcesURL
    }
    
    fileprivate func iconPath(appId: Int64) -> URL {
        let resourcesURL = worker.resoursePath(with: appId)
        return resourcesURL.appendingPathComponent(appIconFilename)
    }
    
    fileprivate func screenshotPath(appId: Int64, index: Int) -> URL {
        let resourcesURL = worker.resoursePath(with: appId)
        return resourcesURL.appendingPathComponent("screenshot_\(index).jpg")
    }
    
    
    static func removeALLMediaAssets() {
        let docsURL = worker.docsDirURL()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: docsURL,
                                                                           includingPropertiesForKeys: nil,
                                                                           options: .skipsHiddenFiles)
            for url in fileURLs {
                try FileManager.default.removeItem(at: url)
            }
            
        } catch {
            Logger().info("\(#function): unable to remove all media assets")
        }
    }
    
    
    // pjh: write and forget
    static func saveJSONResponse(source: [String: Any]?, appId: Int64, term: String) {
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
    
    
    static func saveAppIcon(rawData: Data?, appId: Int64, term: String) {
        iconQueue.async {
            let filepathURL = worker.iconPath(appId: appId, term: term)
            if let data = rawData {
                if let image = UIImage(data: data)?.jpegData(compressionQuality: 1) {
                    try? image.write(to: filepathURL)
                }
            }
        }
    }
    
    
    static func appIcon(for appId: Int64, term: String) -> UIImage? {
        let filepathURL = worker.iconPath(appId: appId, term: term)
        return UIImage(contentsOfFile: filepathURL.path)
    }
    
    static func screenshotURLSFromJSONFile(for appId: Int64, term: String) -> [URL]? {
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
    
    
    static func sceenshot(for appId: Int64, term: String, index: Int) -> UIImage? {
        let url = worker.screenshotPath(appId: appId,
                                        term: term,
                                        index: index + 1)
        
        print("url path: \(url.path)")
        
        return UIImage(contentsOfFile: url.path)
    }
    
    static func saveScreenshot(_ rawData: Data?,
                               _ appId: Int64,
                               _ term: String,
                               _ index: Int,
                               _ process: @escaping(Int64, String, Int, ApplicationErrorType) -> ()) {
        screenshotQueue.async {
            let filepathURL = worker.screenshotPath(appId: appId, term: term, index: index + 1)
            if let data = rawData {
                if let image = UIImage(data: data)?.jpegData(compressionQuality: 1) {
                    try? image.write(to: filepathURL)
                    process(appId, term, index, .okayNoErrorCode)
                }
            }
        }
    }
}


// pjh: internal worker - dettached from service interface
let worker = FileSystemService()
