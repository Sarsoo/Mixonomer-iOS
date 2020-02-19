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
    case runPlaylist(name: String)
    case updatePlaylist(name: String, updates: JSON)
}

extension PlaylistApi: ApiRequest {
    var domain: String {
        return ApiRequestDefaults.domain
    }
    
    var path: String {
        switch self {
        case .getPlaylists:
            return "api/playlists"
        case .runPlaylist:
            return "api/playlist/run"
        case .updatePlaylist:
            return "api/playlist"
        }
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .getPlaylists:
            return .get
        case .runPlaylist:
            return .get
        case .updatePlaylist:
            return .post
        }
    }
    
    var parameters: JSON? {
        switch self {
        case .getPlaylists:
            return nil
        case .runPlaylist(let name):
            return JSON(["name": name])
        case .updatePlaylist(let name, let updates):
            var txUpdates = updates
            txUpdates["name"].string = name
            debugPrint(txUpdates)
            return txUpdates
        }
    }
    
    var parameterType: ParameterEncoder? {
        switch self {
        case .getPlaylists:
            return nil
        case .runPlaylist:
            return URLEncodedFormParameterEncoder()
        case .updatePlaylist:
            return JSONParameterEncoder.default
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authMethod: AuthMethod? {
        return ApiRequestDefaults.authMethod
    }
    
    
}

