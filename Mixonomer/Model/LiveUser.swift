//
//  LiveUser.swift
//  Mixonomer
//
//  Created by Andy Pack on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainAccess
import OSLog

class LiveUser: ObservableObject {
    
    @Published var playlists: [Playlist]
    @Published var tags: [Tag]
    @Published var username: String
    @Published var user: User?
    
    @Published var loggedIn: Bool {
        didSet {
            UserDefaults.standard.set(loggedIn, forKey: "loggedIn")
        }
    }
    
    @Published var isRefreshingUser = false
    @Published var isRefreshingPlaylists = false
    @Published var isRefreshingTags = false
    
    init(playlists: [Playlist], tags: [Tag], username: String, loggedIn: Bool) {
        self.playlists = playlists
        self.tags = tags
        self.username = username
        self.loggedIn = loggedIn
    }
    
    init(playlists: [Playlist], tags: [Tag], username: String, loggedIn: Bool, user: User) {
        self.playlists = playlists
        self.tags = tags
        self.username = username
        self.loggedIn = loggedIn
        self.user = user
    }
    
    func lastfm_connected() -> Bool {
        if let username = user?.lastfm_username {
            return username.count > 0
        }
        
        return false
    }
    
    func logout() {
        let keychain = Keychain(service: "xyz.sarsoo.music.login")
        
        Logger.sys.info("logging user out")
        
        do {
            try keychain.remove("username")
            try keychain.remove("jwt")
            
            playlists.removeAll()
            tags.removeAll()
            username = ""
            user = nil
            
            UserDefaults.standard.removeObject(forKey: "playlists")
            UserDefaults.standard.removeObject(forKey: "tags")
            
            self.loggedIn = false
            
            Logger.sys.debug("successfully logged user out")
            
        } catch let error {
            Logger.sys.error("could not clear keychain, \(error)")
        }
    }
    
    func update_playlist(playlistIn: Playlist) {
        guard let index = self.playlists.firstIndex(of: playlistIn) else {
            fatalError("\(playlistIn) not found")
        }
        self.playlists[index] = playlistIn
    }
    
    func refresh_user(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        self.isRefreshingUser = true
        
        Logger.sys.info("refreshing user")
        
        let api = UserApi.getUser
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.check_network_response(response: response) {
                
                guard let data = response.data else {
                    Logger.net.error("error getting user")
                    return
                }

                guard let json = try? JSON(data: data) else {
                    Logger.parse.error("error parsing user")
                    return
                }
                
                // update state
                self.user = UserApi.fromJSON(user: json)
                
                self.isRefreshingUser = false
                
                if let success = onSuccess {
                    Logger.sys.debug("successfully refreshed user")
                    success()
                }
                
            } else {
                
                if let failure = onFailure {
                    Logger.net.error("failed to refresh user")
                    failure()
                }
            }
        }
    }
    
    func refresh_playlists(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        self.isRefreshingPlaylists = true
        
        Logger.sys.info("refreshing playlists")

        let api = PlaylistApi.getPlaylists
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.check_network_response(response: response) {
                
                guard let data = response.data else {
                    Logger.net.error("error getting playlists from net request")
                    return
                }

                guard let json = try? JSON(data: data) else {
                    Logger.parse.error("error parsing playlists reponse")
                    return
                }
                    
                let playlists = json["playlists"].arrayValue
                
                // update state
                self.playlists = PlaylistApi.fromJSON(playlist: playlists).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                
                self.isRefreshingPlaylists = false
                
                if let success = onSuccess {
                    Logger.sys.debug("successfully refreshed playlists")
                    success()
                }
                
                let encoder = JSONEncoder()
                do {
                    UserDefaults.standard.set(String(data: try encoder.encode(playlists), encoding: .utf8), forKey: "playlists")
                } catch {
                    Logger.parse.error("error encoding playlists: \(error)")
                }
                
            } else {
                
                if let failure = onFailure {
                    Logger.net.error("failed to refresh playlists")
                    failure()
                }
            }
        }
    }
    
    func refresh_tags(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        self.isRefreshingTags = true

        Logger.sys.info("refreshing tags")
        
        let api = TagApi.getTags
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.check_network_response(response: response) {
                
                guard let data = response.data else {
                    Logger.net.error("error getting tags")
                    return
                }

                guard let json = try? JSON(data: data) else {
                    Logger.parse.error("error parsing tags response")
                    return
                }
                    
                let tags = json["tags"].arrayValue
                
                // update state
                self.tags = TagApi.fromJSON(tag: tags).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                
                self.isRefreshingTags = false
                
                if let success = onSuccess {
                    Logger.sys.debug("successfully refreshed tags")
                    success()
                }
                
                let encoder = JSONEncoder()
                do {
                    UserDefaults.standard.set(String(data: try encoder.encode(tags), encoding: .utf8), forKey: "tags")
                } catch {
                    Logger.parse.error("error encoding tags: \(error)")
                }
                
            } else {
                
                if let failure = onFailure {
                    Logger.net.error("failed to refresh tags")
                    failure()
                }
            }
        }
    }
    
    func check_network_response(response: AFDataResponse<Any>) -> Bool {
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 401: // token has expired
                Logger.sys.info("token expired, logging user out")
                self.logout()
                return false
            case 400..<500:
                Logger.net.error("client fault \(statusCode)")
                return false
            case 500..<600:
                Logger.net.warning("server fault \(statusCode)")
                return false
            case _: // 200 -> Success
                return true
            }
        }
        
        Logger.net.error("live user failed to access status code to check")
        
        return false
    }
    
    func load_user_defaults() -> LiveUser {
        Logger.sys.debug("loading user defaults")
        
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        let _strPlaylists = defaults.string(forKey: "playlists")
        let _strTags = defaults.string(forKey: "tags")
        loggedIn = defaults.bool(forKey: "loggedIn")
        
        do {
            if let _strPlaylists = _strPlaylists {
                if _strPlaylists.count > 0 {
                    Logger.sys.debug("reading \(_strPlaylists.count) playlists")
                    self.playlists = (try decoder.decode([Playlist].self, from: _strPlaylists.data(using: .utf8)!)).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                }
            }
            
            if let _strTags = _strTags {
                if _strTags.count > 0 {
                    Logger.sys.debug("reading \(_strTags.count) tags")
                    self.tags = (try decoder.decode([Tag].self, from: _strTags.data(using: .utf8)!)).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                }
            }
        } catch {
            Logger.parse.error("error parsing user defaults: \(error)")
        }
        
        return self
    }
}
