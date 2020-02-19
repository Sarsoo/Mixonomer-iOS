//
//  Playlist.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

class Playlist: Identifiable, Equatable {
    
    //MARK: Properties
    
    var name: String
    var uri: String
    var username: String
    
    var include_recommendations: Bool
    var recommendation_sample: Int
    var include_library_tracks: Bool
    
    var parts: Array<String>
    var playlist_references: Array<String>
    
    var shuffle: Bool
    
    //MARK: Initialization
    
    init(name: String,
         uri: String,
         username: String,
         
         include_recommendations: Bool,
         recommendation_sample: Int,
         include_library_tracks: Bool,
         
         parts: Array<String>,
         playlist_references: Array<String>,
         
         shuffle: Bool){
        
        self.name = name
        self.uri = uri
        self.username = username
        
        self.include_recommendations = include_recommendations
        self.recommendation_sample = recommendation_sample
        self.include_library_tracks = include_library_tracks
        
        self.parts = parts
        self.playlist_references = playlist_references
        
        self.shuffle = shuffle
    }
    
    static func fromDict(dictionary: JSON) -> Playlist {
        return Playlist(name: dictionary["name"].stringValue,
                    uri: dictionary["uri"].stringValue,
                    username: dictionary["username"].stringValue,
                    
                    include_recommendations: dictionary["include_recommendations"].boolValue,
                    recommendation_sample: dictionary["recommendation_sample"].intValue,
                    include_library_tracks: dictionary["include_library_tracks"].boolValue,
        
                    parts: dictionary["parts"].arrayObject as! Array<String>,
                    playlist_references: dictionary["playlist_references"].arrayObject as! Array<String>,
            
                    shuffle: dictionary["shuffle"].boolValue)
    }
    
    var link: String {
        let uriSplit = self.uri.components(separatedBy: ":")
        return "https://open.spotify.com/playlist/\(uriSplit.last ?? "")"
    }
    
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.name == rhs.name
//            && lhs.username == rhs.username
    }
    
}
