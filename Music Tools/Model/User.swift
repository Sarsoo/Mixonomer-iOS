//
//  User.swift
//  Music Tools
//
//  Created by Andy Pack on 18/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

enum UserType: String {
    case user = "user"
    case admin = "admin"
}

class User: Identifiable {
    
    //MARK: Properties
    
    var username: String
    var email: String?
    var type: UserType
    
    var last_login: String
    var spotify_linked: Bool
    var lastfm_username: String?
    
    //MARK: Initialization
    
    init(username: String,
         email: String?,
         type: UserType = .user,
    
         last_login: String,
         spotify_linked: Bool,
         lastfm_username: String?){
        
        self.username = username
        self.email = email
        self.type = type
        
        self.last_login = last_login
        self.spotify_linked = spotify_linked
        self.lastfm_username = lastfm_username
    }
    
    static func fromDict(dictionary: JSON) -> User {
        return User(username: dictionary["username"].stringValue,
                    email: dictionary["username"].stringValue,
                    type: UserType(rawValue: dictionary["type"].stringValue) ?? .user,
                    last_login: dictionary["last_login"].stringValue,
                    spotify_linked: dictionary["spotify_linked"].boolValue,
                    lastfm_username: dictionary["lastfm_username"].stringValue)
    }
    
}

