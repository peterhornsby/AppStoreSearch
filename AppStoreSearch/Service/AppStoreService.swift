//
//  AppStoreService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import Foundation
import os.log

struct AppStoreServiceError: Error {

    enum ErrorType {
        case failedURLEncoding
        case failedToDecodeHTTPResponse
        case queryTimedOut
    }
    
    let code = ApplicationErrorType.appStoreServiceErrorCode
    let type: ErrorType
    let text: String

}


struct AppStoreService {
    
    
    static var numberOfResultsPerQuery = 30 // 1 to 200 per API
    
    static func queryStore(term: String, limit: Int = 0, makeAppEntity: ([String: Any]) -> AppEntity?) async throws -> (apps:[AppEntity], code: ApplicationErrorType) {
        var appEntities: [AppEntity] = []
        var limitToUse = limit
        if limit <= 0 {
            limitToUse = numberOfResultsPerQuery
        }
        
        guard let url = URL(string: AppStoreService.buildURLString(term, limitToUse)) else {
            let message = "AppStoreService: failed to create URL"
            throw AppStoreServiceError(type: .failedURLEncoding, text: message)
        }
        
        Logger().info("AppStoreService: will use query: \(url.absoluteString)")
        
        // pjh: todo: check http response
        let (rawData, rawResponse) = try await URLSession.shared.data(from: url)
        
        do {
            let json = try JSONSerialization.jsonObject(with: rawData, options: [])
            if let dictionary = json as? [String: Any] {
                if let items = dictionary["results"] as? [Any] {
                    for item in items  {
                        if let dict = item as? [String: Any] {
                            if let entity = makeAppEntity(dict) {
                                appEntities.append(entity)
                                FileSystemService.saveJSONResponse(source: dict, appId: entity.id)
                            } else {
                                // pjh: decide if should throw error here
                                print("NO ENTITY CREATED")
                            }
                        }
                    }
                }
            }
            
        } catch {
            let message = "AppStoreService: failed decode HTTP response"
            throw AppStoreServiceError(type: .failedToDecodeHTTPResponse, text: message)
        }
        
        
        
        return (apps:appEntities, code: .okayNoErrorCode)
    }
    
    // pjh: would like to pass in limit from UI but will default to a value here for now
    private static func buildURLString(_ term: String, _ limit: Int = 1) -> String {
        return "https://itunes.apple.com/search?term=\(term)&entity=software&limit=\(limit)"
    }
    
   
    
}
