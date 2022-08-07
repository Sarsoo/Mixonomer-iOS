//
//  UserApi.swift
//  Mixonomer
//
//  Created by Andy Pack on 18/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum UserApi {
    case getUser
}

extension UserApi: ApiRequest {
    var domain: String {
        return ApiRequestDefaults.domain
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "api/user"
        }
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .getUser:
            return .get
        }
    }
    
    var parameters: JSON? {
        return nil
    }
    
    var parameterType: ParameterEncoder? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authMethod: AuthMethod? {
        return ApiRequestDefaults.authMethod
    }
    
    
}
