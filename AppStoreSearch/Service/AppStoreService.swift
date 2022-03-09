//
//  AppStoreService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import Foundation
import os.log

let numberOfResultsPerQuery = 1


struct AppStoreServiceError: Error {

    enum ErrorType {
        case failedURLEncoding
        case queryTimedOut
    }
    
    let code = ApplicationErrorType.appStoreServiceErrorCode
    let type: ErrorType
    let text: String

}


struct AppStoreService {
    
    static func queryStore(term: String, limit: Int = 0) async throws -> ([AppEntity], Int) {
        var limitToUse = limit
        if limit <= 0 {
            limitToUse = numberOfResultsPerQuery
        }
        
        guard let url = URL(string: AppStoreService.buildURLString(term, limitToUse)) else {
            let message = "AppStoreService: failed to create a URL object"
            
            throw AppStoreServiceError(type: .failedURLEncoding, text: message)
        }
        
        
        
        
        
        Logger().info("AppStoreService: will use query: \(url.absoluteString)")
        
        let (rawResponse, _) = try await URLSession.shared.data(from: url)
        
        
        
        
        
        
        return ([], 0)
    }
    
    // pjh: would like to pass in limit from UI but will default to a value here for now
    private static func buildURLString(_ term: String, _ limit: Int = 1) -> String {
        return "https://itunes.apple.com/search?\(term)=ibm&entity=software&limit=\(limit)"
    }
}
