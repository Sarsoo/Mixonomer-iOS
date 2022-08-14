//
//  AdminApi.swift
//  Mixonomer
//
//  Created by Andy Pack on 13/08/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum AdminApi {
    case getUsers
}

extension AdminApi: ApiRequest {
    var domain: String {
        return ApiRequestDefaults.domain
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "api/users"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var parameters: JSON? {
        nil
    }
    
    var parameterType: ParameterEncoder? {
        nil
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var authMethod: AuthMethod? {
        return ApiRequestDefaults.authMethod
    }
    

}
