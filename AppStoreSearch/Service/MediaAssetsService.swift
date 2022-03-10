//
//  MediaAssetsService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/9/22.
//

import Foundation

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


struct MediaAssetsService {
    
}
