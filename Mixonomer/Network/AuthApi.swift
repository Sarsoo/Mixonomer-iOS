//
//  AuthApi.swift
//  Mixonomer
//
//  Created by Andy Pack on 08/08/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public enum AuthApi {
    case token(username: String, password: String, expiry: Int)
    case register(username: String, password: String, password2: String)
}

extension AuthApi: ApiRequest {
    var domain: String {
        return ApiRequestDefaults.domain
    }
    
    var path: String {
        switch self {
            case .token:
                return "auth/token"
            case .register:
                return "auth/register"
        }
    }
    
    
    var httpMethod: HTTPMethod {
        switch self {
        case .token:
            return .post
        case .register:
            return .post
        }
    }
    
    var parameters: JSON? {
        switch self {
        case .token(let username, let password, let expiry):
            return JSON(["username": username, "password": password, "expiry": expiry])
        case .register(let username, let password, let password2):
            return JSON(["username": username, "password": password, "password_again": password2])
        }
    }
    
    var parameterType: ParameterEncoder? {
        switch self {
        case .token:
            return JSONParameterEncoder.default
        case.register:
            return JSONParameterEncoder.default
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authMethod: AuthMethod? {
        return AuthMethod.none
    }
}
