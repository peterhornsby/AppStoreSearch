//
//  MediaAssetsService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/9/22.
//

import Foundation
import UIKit
import os.log

struct MediaAssetsServiceError: Error {

    enum ErrorType {
        case failedURLEncoding
        case failedToDecodeHTTPResponse
        case queryTimedOut
    }
    
    let code = ApplicationErrorType.mediaAssetsServiceErrorCode
    let type: ErrorType
    let text: String

}

let serviceName = "MediaAssetsService"

struct MediaAssetsService {
    
    static func requestForAppIcon(url: String,
                                  appId: UUID,
                                  processAppIcon:(UUID, UIImage?) -> ()
                                    ) async throws -> (UUID, ApplicationErrorType) {
        
        guard let url = URL(string: url) else {
            let message = "MediaAssetsService: failed to create URL"
            throw AppStoreServiceError(type: .failedURLEncoding, text: message)
        }
        
        Logger().info("MediaAssetsService: will use query: \(url.absoluteString)")
        // pjh: todo: check http response
        let (rawData, rawResponse) = try await URLSession.shared.data(from: url)
        
        //Logger().info("MediaAssetsService: got http response: \(rawResponse)")
        let image = UIImage(data: rawData)
        processAppIcon(appId, image)
        
        return (appId, .okayNoErrorCode)
    }
}
