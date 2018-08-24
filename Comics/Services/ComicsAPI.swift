//
//  ComicsAPI.swift
//  Comics
//
//  Created by Maria on 8/23/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

import Foundation
import Moya
import SwiftHash

enum ComicsAPI {
    
    //private key is hidden according to https://developer.marvel.com/documentation/authorization
    static private let publicApiKey = "PUBLIC_API_KEY"
    static private let privateApiKey = "PRIVATE_API_KEY"
    
    case getComics
}

extension ComicsAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .getComics:
            return URL(string: "https://gateway.marvel.com:443/v1/public")!
        }
    }
    
    var path: String {
        switch self {
        case .getComics:
            return "/comics"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComics:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getComics:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var parameters: [String:Any] {
        switch self {
        case .getComics:
            let ts = "\(Int(NSDate().timeIntervalSince1970))"
            let hash = MD5(ts + ComicsAPI.privateApiKey + ComicsAPI.publicApiKey).lowercased()
            
            return ["hash" : hash,
                    "apikey" : ComicsAPI.publicApiKey,
                    "ts" : ts,
                    "startYear" : 2018,
                    "orderBy" : "title",
                    "limit" : 10]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getComics:
            return ["Content-Type": "application/json", "Accept": "application/json"]
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
}
