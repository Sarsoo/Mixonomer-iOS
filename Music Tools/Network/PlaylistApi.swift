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

let txTypeHeaders = ["default", "recents", "fmchart"]

public enum PlaylistType: Int {
    case defaultPlaylist = 0
    case recents = 1
    case fmchart = 2
}

public enum PlaylistApi {
    case getPlaylists
    case runPlaylist(name: String)
    case updatePlaylist(name: String, updates: JSON)
    case deletePlaylist(name: String)
    case newPlaylist(name: String, type: PlaylistType)
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
        case .deletePlaylist:
            return "api/playlist"
        case .newPlaylist:
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
        case .deletePlaylist:
            return .delete
        case .newPlaylist:
            return .put
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
            return txUpdates
        case .deletePlaylist(let name):
            return JSON(["name": name])
        case .newPlaylist(let name, let type):
            return JSON(["name": name, "type": txTypeHeaders[type.rawValue]])
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
        case .deletePlaylist:
            return URLEncodedFormParameterEncoder()
        case .newPlaylist:
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

