//
//  Playlist.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Playlist: Identifiable, Equatable, Codable {
    
    //MARK: Properties
    
    var name: String
    var uri: String
    var username: String?
    
    var include_recommendations: Bool
    var recommendation_sample: Int
    var include_library_tracks: Bool
    
    var parts: Array<String>
    var playlist_references: Array<String>
    var shuffle: Bool
    
    var sort: String
    var description_overwrite: String?
    var description_suffix: String?
    
    var last_updated: String?
    
    var lastfm_stat_count: Int
    var lastfm_stat_album_count: Int
    var lastfm_stat_artist_count: Int
    
    var lastfm_stat_percent: Float
    var lastfm_stat_percent_str: String {
        get {
            return String(format: "%.2f%%", lastfm_stat_percent)
        }
    }
    var lastfm_stat_album_percent: Float
    var lastfm_stat_album_percent_str: String {
        get {
            return String(format: "%.2f%%", lastfm_stat_album_percent)
        }
    }
    var lastfm_stat_artist_percent: Float
    var lastfm_stat_artist_percent_str: String {
        get {
            return String(format: "%.2f%%", lastfm_stat_artist_percent)
        }
    }
    
    var lastfm_stat_last_refresh: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case uri
        case username
        
        case include_recommendations
        case recommendation_sample
        case include_library_tracks
        
        case parts
        case playlist_references
        case shuffle
        
        case sort
        case description_overwrite
        case description_suffix
        
        case last_updated
        
        case lastfm_stat_count
        case lastfm_stat_album_count
        case lastfm_stat_artist_count
        
        case lastfm_stat_percent
        case lastfm_stat_album_percent
        case lastfm_stat_artist_percent
        
        case lastfm_stat_last_refresh
    }
    
    //MARK: Initialization
    
    init(name: String,
         uri: String = "spotify::",
         username: String = "NO USER",

         include_recommendations: Bool = false,
         recommendation_sample: Int = 0,
         include_library_tracks: Bool = false,

         parts: Array<String> = [],
         playlist_references: Array<String> = [],
         shuffle: Bool = false,
         
         sort: String = "NO SORT",
         description_overwrite: String? = nil,
         description_suffix: String? = nil,
         
         last_updated: String? = "",
         
         lastfm_stat_count: Int = 0,
         lastfm_stat_album_count: Int = 0,
         lastfm_stat_artist_count: Int = 0,
         
         lastfm_stat_percent: Float = 0,
         lastfm_stat_album_percent: Float = 0,
         lastfm_stat_artist_percent: Float = 0,
         
         lastfm_stat_last_refresh: String? = ""){

        self.name = name
        self.uri = uri
        self.username = username
        
        self.last_updated = last_updated
        
        self.lastfm_stat_count = lastfm_stat_count
        self.lastfm_stat_album_count = lastfm_stat_album_count
        self.lastfm_stat_artist_count = lastfm_stat_artist_count
        
        self.lastfm_stat_percent = lastfm_stat_percent
        self.lastfm_stat_album_percent = lastfm_stat_album_percent
        self.lastfm_stat_artist_percent = lastfm_stat_artist_percent
        
        self.lastfm_stat_last_refresh = lastfm_stat_last_refresh

        self.include_recommendations = include_recommendations
        self.recommendation_sample = recommendation_sample
        self.include_library_tracks = include_library_tracks

        self.parts = parts
        self.playlist_references = playlist_references
        self.shuffle = shuffle
        
        self.sort = sort
        self.description_overwrite = description_overwrite
        self.description_suffix = description_suffix
    }
    
    var link: String {
        let uriSplit = self.uri.components(separatedBy: ":")
        return "https://open.spotify.com/playlist/\(uriSplit.last ?? "")"
    }
    
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.name == rhs.name
//            && lhs.username == rhs.username
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        uri = try container.decode(String.self, forKey: .uri)
//        username = try container.decode(String.self, forKey: .username)
        
//        description_overwrite = try container.decode(String.self, forKey: .description_overwrite)
//        description_suffix = try container.decode(String.self, forKey: .description_suffix)
        
        last_updated = try container.decode(String.self, forKey: .last_updated)
        
        lastfm_stat_count = try container.decode(Int.self, forKey: .lastfm_stat_count)
        lastfm_stat_album_count = try container.decode(Int.self, forKey: .lastfm_stat_album_count)
        lastfm_stat_artist_count = try container.decode(Int.self, forKey: .lastfm_stat_artist_count)
        
        lastfm_stat_percent = try container.decode(Float.self, forKey: .lastfm_stat_percent)
        lastfm_stat_album_percent = try container.decode(Float.self, forKey: .lastfm_stat_album_percent)
        lastfm_stat_artist_percent = try container.decode(Float.self, forKey: .lastfm_stat_artist_percent)
        
        lastfm_stat_last_refresh = try container.decode(String.self, forKey: .lastfm_stat_last_refresh)
        
        include_recommendations = try container.decode(Bool.self, forKey: .include_recommendations)
        recommendation_sample = try container.decode(Int.self, forKey: .recommendation_sample)
        include_library_tracks = try container.decode(Bool.self, forKey: .include_library_tracks)
        
        parts = try container.decode([String].self, forKey: .parts)
        playlist_references = try container.decode([String].self, forKey: .playlist_references)
        shuffle = try container.decode(Bool.self, forKey: .shuffle)
        
        sort = try container.decode(String.self, forKey: .sort)
    }
    
}

class RecentsPlaylist: Playlist {
    
    //MARK: Properties
    
    var add_last_month: Bool
    var add_this_month: Bool
    var day_boundary: Int
    
    private enum CodingKeys: String, CodingKey { case add_last_month; case add_this_month; case day_boundary }
    
    //MARK: Initialization
    
    init(name: String,
         username: String = "NO USER",
         
         add_last_month: Bool = false,
         add_this_month: Bool = false,
         day_boundary: Int = 14){

        self.add_last_month = add_last_month
        self.add_this_month = add_this_month
        self.day_boundary = day_boundary
        
        super.init(name: name, username: username)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        add_last_month = try container.decode(Bool.self, forKey: .add_last_month)
        add_this_month = try container.decode(Bool.self, forKey: .add_this_month)
        day_boundary = try container.decode(Int.self, forKey: .day_boundary)
        
        try super.init(from: decoder)
    }
}

enum LastFmRange: String, Decodable {
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
    
    private enum CodingKeys: String, CodingKey { case chart_range; case chart_limit }
    
    //MARK: Initialization
    
    init(name: String,
         username: String = "NO USER",
         
         chart_range: LastFmRange = .overall,
         chart_limit: Int = 10){

        self.chart_range = chart_range
        self.chart_limit = chart_limit
        
        super.init(name: name, username: username)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chart_range = try LastFmRange(rawValue: container.decode(String.self, forKey: .chart_range))!
        chart_limit = try container.decode(Int.self, forKey: .chart_limit)
        
        try super.init(from: decoder)
    }
}
