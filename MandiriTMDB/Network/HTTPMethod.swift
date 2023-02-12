//
//  HTTPMethod.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 10/02/23.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

struct NetworkConfiguration {
    fileprivate static let base_url = "https://api.themoviedb.org/3/"
    static let kTokenExpiredErrorCode = 405
    static let kGatewayTimeoutErrorCode = 503
    static let kMissingPhoneNumberErrorCode = 403
    static let sessionExpired = 401
    
    static let apiKey = "37d93132bd2d64d208704da776a15349"
    static var envBaseUrl: String = {
        return base_url
    }()
    
    static func api(_ apiType: APIUrl) -> String {
        return envBaseUrl + apiType.apiString()
    }
}
