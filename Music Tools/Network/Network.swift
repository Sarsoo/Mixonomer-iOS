//
//  Network.swift
//  Music Tools
//
//  Created by Andy Pack on 18/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainAccess

public enum AuthMethod {
    case basic
    
    func auth(headers: Alamofire.HTTPHeaders?) -> Alamofire.HTTPHeaders {
        switch self {
        case .basic:
            var txHeaders = headers ?? HTTPHeaders()
            
            let keychain = Keychain(service: "xyz.sarsoo.music.login")
            txHeaders.add(.authorization(username: keychain["username"] ?? "", password: keychain["password"] ?? ""))
            return txHeaders
        }
    }
}

struct RequestBuilder {
    static func buildRequest(apiRequest: ApiRequest) -> Alamofire.DataRequest {
        
        let txHeaders = apiRequest.authMethod?.auth(headers: apiRequest.headers)
        
        if apiRequest.parameters != nil {
            if apiRequest.parameterType != nil {
                
                let txEncoder = apiRequest.parameterType ?? JSONParameterEncoder.default
                
                return AF.request(apiRequest.domain + apiRequest.path,
                                  method: apiRequest.httpMethod,
                                  parameters: apiRequest.parameters,
                                  encoder: txEncoder,
                                  headers: txHeaders)
            } else {
                return AF.request(apiRequest.domain + apiRequest.path,
                                  method: apiRequest.httpMethod,
                                  parameters: apiRequest.parameters,
                                  headers: txHeaders)
            }
        }
        return AF.request(apiRequest.domain + apiRequest.path,
                          method: apiRequest.httpMethod,
                          headers: txHeaders)
    }
}

struct ApiRequestDefaults {
    static let authMethod: AuthMethod = .basic
    static let domain: String = "https://music.sarsoo.xyz/"
}

protocol ApiRequest {
    var domain: String { get }
    var path: String { get }
    var httpMethod: Alamofire.HTTPMethod { get }
    var parameters: JSON? { get }
    var parameterType: Alamofire.ParameterEncoder? { get }
    var headers: HTTPHeaders? { get }
    var authMethod: AuthMethod? { get }
}
