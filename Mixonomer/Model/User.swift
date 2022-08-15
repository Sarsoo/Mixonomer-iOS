//
//  User.swift
//  Mixonomer
//
//  Created by Andy Pack on 18/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

enum UserType: String, Decodable {
    case user = "user"
    case admin = "admin"
}

class User: Identifiable, Decodable {
    
    //MARK: Properties
    
    var username: String
    var email: String?
    var type: UserType
    
    var locked: Bool
    
    var last_login: String
    var last_keygen: String
    var last_refreshed: String
    
    var spotify_linked: Bool
    @Published var lastfm_username: String?
    
    //MARK: Initialization
    
    init(username: String = "user",
         email: String? = nil,
         type: UserType = .user,
         
         locked: Bool = false,
         
         last_login: String = "",
         last_keygen: String = "",
         last_refreshed: String = "",
         spotify_linked: Bool = true,
         lastfm_username: String? = nil){
        
        self.username = username
        self.email = email
        self.type = type
        
        self.locked = locked
        
        self.last_login = last_login
        self.last_keygen = last_keygen
        self.last_refreshed = last_refreshed
        self.spotify_linked = spotify_linked
        self.lastfm_username = lastfm_username
    }
    
    private enum CodingKeys: String, CodingKey {
        case username
        case email
        case type
        
        case locked
        
        case last_login
        case last_keygen
        case last_refreshed
        
        case spotify_linked
        case lastfm_username
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        username = try container.decode(String.self, forKey: .username)
        do{
            email = try container.decode(String.self, forKey: .email)
        }catch {
            email = nil
        }
            
        type = try container.decode(UserType.self, forKey: .type)
        locked = try container.decode(Bool.self, forKey: .locked)
        
        last_login = try container.decode(String.self, forKey: .last_login)
        do{
            last_keygen = try container.decode(String.self, forKey: .last_keygen)
        }catch {
            last_keygen = ""
        }
        do{
            last_refreshed = try container.decode(String.self, forKey: .last_refreshed)
        }catch {
            last_refreshed = ""
        }
        
        spotify_linked = try container.decode(Bool.self, forKey: .spotify_linked)
        do{
            lastfm_username = try container.decode(String.self, forKey: .lastfm_username)
        }catch {
            lastfm_username = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.username, forKey: .username)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.type.rawValue, forKey: .type)
        
        try container.encode(self.locked, forKey: .locked)
        
        try container.encode(self.last_login, forKey: .last_login)
        try container.encode(self.last_keygen, forKey: .last_keygen)
        try container.encode(self.last_refreshed, forKey: .last_refreshed)
        
        try container.encode(self.spotify_linked, forKey: .spotify_linked)
        try container.encode(self.lastfm_username, forKey: .lastfm_username)
    }
}

