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
    case updateUser(updates: JSON)
    case deleteUser
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
        }
    }
    
    var parameters: JSON? {
        switch self {
        case .getUser, .deleteUser:
            return nil
        case .updateUser(let updates):
            return updates
        }
    }
    
    var parameterType: ParameterEncoder? {
        switch self {
        case .getUser, .deleteUser:
            return nil
        case .updateUser:
            return JSONParameterEncoder.default
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authMethod: AuthMethod? {
        return ApiRequestDefaults.authMethod
    }
    
    static func fromJSON(user: Data) -> User? {
        
        let decoder = JSONDecoder()
        do {
            let user = try decoder.decode(User.self, from: user)
            return user
        } catch {
            print(error)
        }
        return nil
    }
    
    static func fromJSON(user: JSON) -> User? {
        
        let _json = user.rawString()?.data(using: .utf8)
        
        if let data = _json {
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    static func fromJSON(user: [JSON]) -> [User] {
        var _users: [User] = []
        for dict in user {
            let _iter = self.fromJSON(user: dict)
            if let returned = _iter {
                _users.append(returned)
            }
        }
        return _users
    }
}
