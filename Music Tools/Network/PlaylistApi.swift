//
//  PlaylistApi.swift
//  Music Tools
//
//  Created by Andy Pack on 18/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum PlaylistApi {
    case getPlaylists
}

extension PlaylistApi: ApiRequest {
    var domain: String {
        return ApiRequestDefaults.domain
    }
    
    var path: String {
        switch self {
        case .getPlaylists:
            return "api/playlists"
        }
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .getPlaylists:
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

