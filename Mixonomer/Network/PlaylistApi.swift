//
//  PlaylistApi.swift
//  Mixonomer
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
    case getPlaylist(name: String)
    case refreshStats(name: String)
    
    case addPart(name: String, subject: String)
    case removePart(name: String, subject: String)
    case addRef(name: String, subject: String)
    case removeRef(name: String, subject: String)
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
        case .getPlaylist:
            return "api/playlist"
        case .refreshStats:
            return "api/spotfm/playlist/refresh"
        case .addPart, .removePart, .addRef, .removeRef:
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
        case .getPlaylist:
            return .get
        case .refreshStats:
            return .get
        case .addPart, .removePart, .addRef, .removeRef:
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
            return txUpdates
        case .deletePlaylist(let name):
            return JSON(["name": name])
        case .newPlaylist(let name, let type):
            return JSON(["name": name, "type": txTypeHeaders[type.rawValue]])
        case .getPlaylist(let name):
            return JSON(["name": name])
        case .refreshStats(let name):
            return JSON(["name": name])
        case .addPart(let name, let subject):
            return JSON(["name": name, "subject": subject])
        case .removePart(let name, let subject):
            return JSON(["name": name, "subject": subject])
        case .addRef(let name, let subject):
            return JSON(["name": name, "subject": subject])
        case .removeRef(let name, let subject):
            return JSON(["name": name, "subject": subject])
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
        case .getPlaylist:
            return URLEncodedFormParameterEncoder()
        case .refreshStats:
            return URLEncodedFormParameterEncoder()
        case .addPart, .removePart, .addRef, .removeRef:
            return JSONParameterEncoder.default
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authMethod: AuthMethod? {
        return ApiRequestDefaults.authMethod
    }
    
    static func fromJSON(playlist: Data) -> Playlist? {
        
        let decoder = JSONDecoder()
        do {
            let playlist = try decoder.decode(Playlist.self, from: playlist)
            return playlist
        } catch {
            print(error)
        }
        return nil
    }
    
    static func fromJSON(playlist: JSON) -> Playlist? {
        
        let _json = playlist.rawString()?.data(using: .utf8)
        
        if let data = _json {
            let decoder = JSONDecoder()
            do {
                let playlist = try decoder.decode(Playlist.self, from: data)
                return playlist
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    static func fromJSON(playlist: [JSON]) -> [Playlist] {
        var _playlists: [Playlist] = []
        for dict in playlist {
            let _iter = self.fromJSON(playlist: dict)
            if let returned = _iter {
                _playlists.append(returned)
            }
        }
        return _playlists
    }
    
}

