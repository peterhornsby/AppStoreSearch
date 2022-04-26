//
//  MediaAssetsService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/9/22.
//

import Foundation
import UIKit
import os.log



let serviceName = "MediaAssetsService"

struct MediaAssetsService {
    
    static func requestForAppIcon(url: String,
                                  appId: Int64,
                                  processAppIcon:(Int64, Data?) -> ()
                                    ) async throws -> (Int64, AppCode) {
        
        guard let url = URL(string: url) else {
            let message = "MediaAssetsService: failed to create URL"
            throw AppError.application(code: AppCode.mediaAssetsServiceErrorCode, message: message)
        }
        
        Logger().info("MediaAssetsService: will use query: \(url.absoluteString)")
        // pjh: todo: check http response
        let (rawData, rawResponse) = try await URLSession.shared.data(from: url)
        
        //Logger().info("MediaAssetsService: got http response: \(rawResponse)")
        processAppIcon(appId, rawData)
        
        return (appId, .okayNoErrorCode)
    }
    
    static func screenshotURLs(for appId: Int64, term: String) -> [URL] {
        guard let urls = FileSystemService.screenshotURLSFromJSONFile(for: appId) else {
            return []
        }
        return urls
    }
    
    
    
    static func requestForAllScreenshots(appId: Int64,
                                         urls: [URL],
                                         term: String,
                                         process:@escaping (Int64, String, Int, AppCode) -> ()) async throws -> AppCode {
        guard urls.count > 0 else { return .okayNoErrorCode }
        
        for (index, url) in urls.enumerated() {
            let result = try await MediaAssetsService.requestForScreenshot(appId: appId,
                                                          url: url,
                                                          term: term,
                                                          index: index,
                                                          process: process)
        }
        
        return .okayNoErrorCode
    }
    
    
    
    
    
    static func requestForScreenshot(appId: Int64,
                                     url: URL,
                                     term: String,
                                     index: Int,
                                     process:@escaping (Int64, String, Int, AppCode) -> ()
                                    ) async throws -> AppCode {

        Logger().info("MediaAssetsService: will fetch screenshot: \(url.absoluteString)")
        // pjh: todo: check http response
        let (rawData, rawResponse) = try await URLSession.shared.data(from: url)

        FileSystemService.saveScreenshot(rawData, appId, term, index, process)
        return .okayNoErrorCode
    }
}
