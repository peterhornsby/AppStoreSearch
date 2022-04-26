//
//  ApplicationErrorCodes.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import Foundation


enum AppError: Error {
    // application errors
    case application(code: AppCode, message: String)
    // Network errors
    case networking(code: AppCode, message: String, httpCode: Int)
    // file IO
    case fileSystem(code: AppCode, message: String)
    // Media Assets
    case mediaAssets(code: AppCode, message: String)
}


enum AppCode: Int {
    // application Errors
    case okayNoErrorCode
    case emptyStringErrorCode
    case nilStringErrorCode
    case urlEncodingErrorCode
    // Network Errors
    case http200OKErrorCode
    case networkUnreachableErrorCode
    case networkLossConnectiveErrorCode
    // AppStore Service
    case appStoreServiceErrorCode
    case searchTermIsEmptyErrorCode
    case searchTermIsNilErrorCode
    // Filesystem Service
    case fileSystemServiceErrorCode
    // Media Assets Service
    case mediaAssetsServiceErrorCode
    
}


extension AppError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .application(code: let code, message: let message):
            return "Error(application) >> message: \(message), code: \(code)"
        case .networking(code: let code, message: let message, httpCode: let httpCode):
            return "Error(networking) >> message: \(message), code: \(code), http code: \(httpCode)"
        case .fileSystem(code: let code, message: let message):
            return "Error(file system) >> message: \(message), code: \(code)"
        case .mediaAssets(code: let code, message: let message):
            return "Error(media assets) >> message: \(message), code: \(code)"
        }
    }
}


//protocol ApplicationError: Error {
//    var code: ApplicationErrorCode { get }
//    var text: String { get }
//    var action: (()->())? { get }
//
//    func describe() -> String
//
//}

//extension ApplicationError {
//    /// pjh: default implementation, override as required
//    func describe() -> String {
//        let description = """
//        -- Application Error(Default) --
//        \tcategory: \(self.category)
//        \tcode: \(self.code)
//        \ttext: \(self.text)
//        \taction to take: \(String(describing: self.action))
//        """
//
//        return description
//    }
//}
