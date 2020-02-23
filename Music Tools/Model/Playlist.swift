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
    
    static func fromDict(dictionary: JSON) -> Playlist? {
        switch dictionary["type"].string {
        case "default":
            return Playlist(name: dictionary["name"].stringValue,
                    uri: dictionary["uri"].stringValue,
                    username: dictionary["username"].stringValue,
                    
                    include_recommendations: dictionary["include_recommendations"].boolValue,
                    recommendation_sample: dictionary["recommendation_sample"].intValue,
                    include_library_tracks: dictionary["include_library_tracks"].boolValue,
        
                    parts: dictionary["parts"].arrayObject as! Array<String>,
                    playlist_references: dictionary["playlist_references"].arrayObject as! Array<String>,
            
                    shuffle: dictionary["shuffle"].boolValue)
        case "recents":
            return RecentsPlaylist(name: dictionary["name"].stringValue,
                    uri: dictionary["uri"].stringValue,
                    username: dictionary["username"].stringValue,
                    
                    include_recommendations: dictionary["include_recommendations"].boolValue,
                    recommendation_sample: dictionary["recommendation_sample"].intValue,
                    include_library_tracks: dictionary["include_library_tracks"].boolValue,
        
                    parts: dictionary["parts"].arrayObject as! Array<String>,
                    playlist_references: dictionary["playlist_references"].arrayObject as! Array<String>,
            
                    shuffle: dictionary["shuffle"].boolValue,
                    
                    add_last_month: dictionary["add_last_month"].boolValue,
                    add_this_month: dictionary["add_this_month"].boolValue,
                    day_boundary: dictionary["day_boundary"].intValue)
        case "fmchart":
            return LastFMChartPlaylist(name: dictionary["name"].stringValue,
                    uri: dictionary["uri"].stringValue,
                    username: dictionary["username"].stringValue,
                    
                    include_recommendations: dictionary["include_recommendations"].boolValue,
                    recommendation_sample: dictionary["recommendation_sample"].intValue,
                    include_library_tracks: dictionary["include_library_tracks"].boolValue,
        
                    parts: dictionary["parts"].arrayObject as! Array<String>,
                    playlist_references: dictionary["playlist_references"].arrayObject as! Array<String>,
            
                    shuffle: dictionary["shuffle"].boolValue,
                    
                    chart_range: LastFmRange(rawValue: dictionary["chart_range"].stringValue)!,
                    chart_limit: dictionary["chart_limit"].intValue)
        default:
            return nil
        }
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

class RecentsPlaylist: Playlist {
    
    //MARK: Properties
    
    var add_last_month: Bool
    var add_this_month: Bool
    var day_boundary: Int
    
    //MARK: Initialization
    
    init(name: String,
         uri: String,
         username: String,
         
         include_recommendations: Bool,
         recommendation_sample: Int,
         include_library_tracks: Bool,
         
         parts: Array<String>,
         playlist_references: Array<String>,
         
         shuffle: Bool,
         
         add_last_month: Bool,
         add_this_month: Bool,
         day_boundary: Int){
        
        self.add_last_month = add_last_month
        self.add_this_month = add_this_month
        self.day_boundary = day_boundary
        
        super.init(name: name, uri: uri, username: username, include_recommendations: include_recommendations, recommendation_sample: recommendation_sample, include_library_tracks: include_library_tracks, parts: parts, playlist_references: playlist_references, shuffle: shuffle)
    }
}

enum LastFmRange: String {
    case overall = "OVERALL"
    case week = "WEEK"
    case month = "MONTH"
    case quarter = "QUARTER"
    case halfyear = "HALFYEAR"
    case year = "YEAR"
}

class LastFMChartPlaylist: Playlist {
    
    //MARK: Properties
    
    var chart_range: LastFmRange
    var chart_limit: Int
    
    //MARK: Initialization
    
    init(name: String,
         uri: String,
         username: String,
         
         include_recommendations: Bool,
         recommendation_sample: Int,
         include_library_tracks: Bool,
         
         parts: Array<String>,
         playlist_references: Array<String>,
         
         shuffle: Bool,
         
         chart_range: LastFmRange,
         chart_limit: Int){
        
        self.chart_range = chart_range
        self.chart_limit = chart_limit
        
        super.init(name: name, uri: uri, username: username, include_recommendations: include_recommendations, recommendation_sample: recommendation_sample, include_library_tracks: include_library_tracks, parts: parts, playlist_references: playlist_references, shuffle: shuffle)
    }
}
