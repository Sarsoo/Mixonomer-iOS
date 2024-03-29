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
import UserNotifications

class LiveUser: ObservableObject {
    
    @Published var playlists: [Playlist]
    @Published var tags: [Tag]
    @Published var username: String
    @Published var user: User
    
    @Published var loggedIn: Bool {
        didSet {
            UserDefaults.standard.set(loggedIn, forKey: "loggedIn")
        }
    }
    
    func requestAPNSPerms(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if error != nil {
                self.handleAPNSFailure()
            }
            else {
                
                // load token from static var and pass to backend server
                APNSHandler.pass_token_to_backend(onFailure: {
                    self.handleAPNSFailure()
                })
            }
        }
    }
    
    func handleAPNSFailure(){
        Logger.sys.debug("failed to get APNS token")
    }
    
    @Published var isFullRefreshingUser = true
    @Published var isFullRefreshingPlaylists = true
    @Published var isFullRefreshingTags = true
    
    @Published var isRefreshingUser = false
    @Published var isRefreshingPlaylists = false
    @Published var isRefreshingTags = false
    
    init(playlists: [Playlist], tags: [Tag], username: String, loggedIn: Bool) {
        self.playlists = playlists
        self.tags = tags
        self.username = username
        self.loggedIn = loggedIn
        self.user = User.get_null_user()
    }
    
    init(playlists: [Playlist], tags: [Tag], username: String, loggedIn: Bool, user: User) {
        self.playlists = playlists
        self.tags = tags
        self.username = username
        self.loggedIn = loggedIn
        self.user = user
    }
    
    var lastfm_connected: Bool {
        get {
            return user.lastfm_username.count > 0
        }
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
            user = User.get_null_user()
            
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
        
        if !isRefreshingUser {
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
                    self.isFullRefreshingUser = false
                    
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
        else
        {
            Logger.sys.info("skipping refreshing user, already refreshing")
        }
    }
    
    func refresh_playlists(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        
        if !isRefreshingPlaylists {
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
                    self.isFullRefreshingPlaylists = false
                    
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
        else
        {
            Logger.sys.info("skipping refreshing playlists, already refreshing")
        }
    }
    
    func refresh_tags(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        
        if !isRefreshingTags {
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
                    self.isFullRefreshingTags = false
                    
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
        else
        {
            Logger.sys.info("skipping refreshing tags, already refreshing")
        }
    }
    
    var isFullRefreshing: Bool {
        get {
            return isFullRefreshingTags || isFullRefreshingPlaylists || isFullRefreshingUser
        }
    }
    
    func full_refresh() {
        
        if !isFullRefreshing {
            self.isFullRefreshingUser = true
            self.isFullRefreshingPlaylists = true
            self.isFullRefreshingTags = true
            
            self.refresh_user()
            self.refresh_playlists()
            self.refresh_tags()
        }
        else
        {
            Logger.sys.info("skipping full refresh, already refreshing")
        }
    }
    
    func check_network_response(response: AFDataResponse<Any>) -> Bool {
        return NetworkHelper.check_network_response(response: response, onTokenFail: {
            self.logout()
        })
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
    
    static func get_preview_user() -> LiveUser {
        return LiveUser(playlists: [], tags: [], username: "user", loggedIn: false)
    }
    
    static func get_preview_user_with_user() -> LiveUser {
        return LiveUser(playlists: [], tags: [], username: "user", loggedIn: false, user: User())
    }
}
