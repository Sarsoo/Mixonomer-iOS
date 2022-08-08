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
    case token(username: String, password: String)
}

extension AuthApi: ApiRequest {
    var domain: String {
        return ApiRequestDefaults.domain
    }
    
    var path: String {
        switch self {
            case .token:
                return "auth/token"
        }
    }
    
    
    var httpMethod: HTTPMethod {
        switch self {
        case .token:
            return .post
        }
    }
    
    var parameters: JSON? {
        switch self {
        case .token(let username, let password):
            return JSON(["username": username, "password": password])
        }
    }
    
    var parameterType: ParameterEncoder? {
        switch self {
        case .token:
            return JSONParameterEncoder.default
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authMethod: AuthMethod? {
        return AuthMethod.none
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
        print(playlist)
        return nil
    }
}
