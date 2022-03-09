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
    case appStoreServiceErrorCode
    // AppStore Service
    case searchTermIsEmptyErrorCode
    case searchTermIsNilErrorCode
}

