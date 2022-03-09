//
//  ApplicationErrorCodes.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import Foundation


enum ApplicationErrorType {
    
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
    
}

