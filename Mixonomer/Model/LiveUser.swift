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
    
    func updatePlaylist(playlistIn: Playlist) {
        guard let index = self.playlists.firstIndex(of: playlistIn) else {
            fatalError("\(playlistIn) not found")
        }
        self.playlists[index] = playlistIn
    }
    
    func refreshUser(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        self.isRefreshingUser = true
        
        let api = UserApi.getUser
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.checkNetworkResponse(response: response) {
                
                guard let data = response.data else {
                    fatalError("error getting user")
                }

                guard let json = try? JSON(data: data) else {
                    fatalError("error parsing user")
                }
                
                // update state
                self.user = UserApi.fromJSON(user: json)
                
                self.isRefreshingUser = false
                
                if let success = onSuccess {
                    success()
                }
                
            } else {
                
                if let failure = onFailure {
                    failure()
                }
            }
        }
    }
    
    func refreshPlaylists(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        self.isRefreshingPlaylists = true
        
        let api = PlaylistApi.getPlaylists
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.checkNetworkResponse(response: response) {
                
                guard let data = response.data else {
                    fatalError("error getting playlists")
                }

                guard let json = try? JSON(data: data) else {
                    fatalError("error parsing reponse")
                }
                    
                let playlists = json["playlists"].arrayValue
                
                // update state
                self.playlists = PlaylistApi.fromJSON(playlist: playlists).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                
                self.isRefreshingPlaylists = false
                
                if let success = onSuccess {
                    success()
                }
                
                let encoder = JSONEncoder()
                do {
                    UserDefaults.standard.set(String(data: try encoder.encode(playlists), encoding: .utf8), forKey: "playlists")
                } catch {
                   print("error encoding playlists: \(error)")
                }
                
            } else {
                
                if let failure = onFailure {
                    failure()
                }
            }
        }
    }
    
    func refreshTags(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        self.isRefreshingTags = true
        
        let api = TagApi.getTags
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.checkNetworkResponse(response: response) {
                
                guard let data = response.data else {
                    fatalError("error getting tags")
                }

                guard let json = try? JSON(data: data) else {
                    fatalError("error parsing reponse")
                }
                    
                let tags = json["tags"].arrayValue
                
                // update state
                self.tags = TagApi.fromJSON(tag: tags).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                
                self.isRefreshingTags = false
                
                if let success = onSuccess {
                    success()
                }
                
                let encoder = JSONEncoder()
                do {
                    UserDefaults.standard.set(String(data: try encoder.encode(tags), encoding: .utf8), forKey: "tags")
                } catch {
                   print("error encoding tags: \(error)")
                }
                
            } else {
                
                if let failure = onFailure {
                    failure()
                }
            }
        }
    }
    
    func checkNetworkResponse(response: AFDataResponse<Any>) -> Bool {
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 401: // token has expired
                self.loggedIn = false
                return false
            case 400..<500:
                return false
            case 500..<600:
                return false
            case _: // 200 -> Success
                return true
            }
        }
        
        return false
    }
    
    func loadUserDefaults() -> LiveUser {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        let _strPlaylists = defaults.string(forKey: "playlists")
        let _strTags = defaults.string(forKey: "tags")
        loggedIn = defaults.bool(forKey: "loggedIn")
        
        do {
            if let _strPlaylists = _strPlaylists {
                if _strPlaylists.count > 0 {
                    self.playlists = (try decoder.decode([Playlist].self, from: _strPlaylists.data(using: .utf8)!)).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                }
            }
            
            if let _strTags = _strTags {
                if _strTags.count > 0 {
                    self.tags = (try decoder.decode([Tag].self, from: _strTags.data(using: .utf8)!)).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                }
            }
        } catch {
          print("error decoding: \(error)")
        }
        
        return self
    }
}
