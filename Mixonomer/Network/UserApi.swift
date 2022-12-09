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
import OSLog

public enum UserApi {
    case getUser
    case updateUser(updates: JSON)
    case deleteUser
    case passAPNSToken(updates: String)
    case updateNotify(state: Bool)
    case updateNotifyPlaylist(state: String)
    case updateNotifyTag(state: String)
    case updateNotifyAdmin(state: String)
}

extension UserApi: ApiRequest {
    var domain: String {
        return ApiRequestDefaults.domain
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "api/user"
        case .updateUser:
            return "api/user"
        case .deleteUser:
            return "api/user"
        case .passAPNSToken:
            return "api/user"
        case .updateNotify, .updateNotifyPlaylist, .updateNotifyTag, .updateNotifyAdmin:
            return "api/user"
        }
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .getUser:
            return .get
        case .updateUser:
            return .post
        case .deleteUser:
            return .delete
        case .passAPNSToken:
            return .post
        case .updateNotify, .updateNotifyPlaylist, .updateNotifyTag, .updateNotifyAdmin:
            return .post
        }
    }
    
    var parameters: JSON? {
        switch self {
        case .getUser, .deleteUser:
            return nil
        case .updateUser(let updates):
            return updates
        case .passAPNSToken(let token):
            return JSON(["apns_token": token])
        case .updateNotify(let state):
            return JSON(["notify": state])
        case .updateNotifyPlaylist(let state):
            return JSON(["notify_playlist_updates": state])
        case .updateNotifyTag(let state):
            return JSON(["notify_tag_updates": state])
        case .updateNotifyAdmin(let state):
            return JSON(["notify_admins": state])
        }
    }
    
    var parameterType: ParameterEncoder? {
        switch self {
        case .getUser, .deleteUser:
            return nil
        case .updateUser, .passAPNSToken:
            return JSONParameterEncoder.default
        case .updateNotify, .updateNotifyPlaylist, .updateNotifyTag, .updateNotifyAdmin:
            return JSONParameterEncoder.default
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authMethod: AuthMethod? {
        return ApiRequestDefaults.authMethod
    }
    
    static func fromJSON(user: Data) -> User {
        
        let decoder = JSONDecoder()
        do {
            let user = try decoder.decode(User.self, from: user)
            return user
        } catch {
            Logger.parse.error("error parsing user from json: \(error)")
            return User.get_null_user()
        }
    }
    
    static func fromJSON(user: JSON) -> User {
        
        let _json = user.rawString()?.data(using: .utf8)
        
        if let data = _json {
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                Logger.parse.error("error parsing user from json: \(error)")
            }
        }
        
        return User.get_null_user()
    }
    
    static func fromJSON(user: [JSON]) -> [User] {
        var _users: [User] = []
        for dict in user {
            let _iter = self.fromJSON(user: dict)
            
            _users.append(_iter)
        }
        return _users
    }
}
