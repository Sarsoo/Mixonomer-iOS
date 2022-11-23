//
//  Playlist.swift
//  Mixonomer
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import OSLog

class Playlist: Identifiable, Equatable, Codable, ObservableObject {
    
    //MARK: Properties
    
    @Published var name: String
    @Published var uri: String
    @Published var username: String?
    
    @Published var type: String {
        didSet {
            self.updatePlaylist(updates: JSON(["type": self.type]))
        }
    }
    
    @Published var include_recommendations: Bool {
        didSet {
            self.updatePlaylist(updates: JSON(["include_recommendations": self.include_recommendations]))
        }
    }
    @Published var recommendation_sample: Int{
        didSet {
            self.updatePlaylist(updates: JSON(["recommendation_sample": self.recommendation_sample]))
        }
    }
    @Published var include_library_tracks: Bool{
        didSet {
            self.updatePlaylist(updates: JSON(["include_library_tracks": self.include_library_tracks]))
        }
    }
    
    @Published var parts: Array<String>{
        didSet {
            self.updatePlaylist(updates: JSON(["parts": self.parts]))
        }
    }
    @Published var playlist_references: Array<String>{
        didSet {
            self.updatePlaylist(updates: JSON(["playlist_references": self.playlist_references]))
        }
    }
    @Published var shuffle: Bool{
        didSet {
            self.updatePlaylist(updates: JSON(["shuffle": self.shuffle]))
        }
    }
    
    var sort: String?
    @Published var description_overwrite: String?
    @Published var description_suffix: String?
    
    @Published var last_updated: String?
    
    @Published var lastfm_stat_count: Int
    @Published var lastfm_stat_album_count: Int
    @Published var lastfm_stat_artist_count: Int
    
    @Published var lastfm_stat_percent: Float
    var lastfm_stat_percent_str: String {
        get {
            return String(format: "%.2f%%", lastfm_stat_percent)
        }
    }
    @Published var lastfm_stat_album_percent: Float
    var lastfm_stat_album_percent_str: String {
        get {
            return String(format: "%.2f%%", lastfm_stat_album_percent)
        }
    }
    @Published var lastfm_stat_artist_percent: Float
    var lastfm_stat_artist_percent_str: String {
        get {
            return String(format: "%.2f%%", lastfm_stat_artist_percent)
        }
    }
    
    @Published var lastfm_stat_last_refresh: String?
    
    @Published var add_last_month: Bool{
        didSet {
            self.updatePlaylist(updates: JSON(["add_last_month": self.add_last_month]))
        }
    }
    @Published var add_this_month: Bool{
        didSet {
            self.updatePlaylist(updates: JSON(["add_this_month": self.add_this_month]))
        }
    }
    @Published var day_boundary: Int{
        didSet {
            self.updatePlaylist(updates: JSON(["day_boundary": self.day_boundary]))
        }
    }
    
    @Published var chart_range: LastFmRange{
        didSet {
            self.updatePlaylist(updates: JSON(["chart_range": self.chart_range.rawValue]))
        }
    }
    @Published var chart_limit: Int{
        didSet {
            self.updatePlaylist(updates: JSON(["chart_range": self.chart_range.rawValue]))
        }
    }
    
    func updatePlaylist(updates: JSON) {
        let api = PlaylistApi.updatePlaylist(name: self.name, updates: updates)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in          
            switch response.response?.statusCode {
            case 200, 201:
                break
            case _:
                Logger.net.error("error: \(self.name), \(updates)")
            }
        }
        //TODO: do better error checking
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case uri
        case username
        
        case type
        
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
        
        case add_last_month
        case add_this_month
        case day_boundary
        
        case chart_range
        case chart_limit
    }
    
    //MARK: Initialization
    
    init(name: String,
         uri: String = "spotify::",
         username: String = "NO USER",
         
         type: String = "default",

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
         
         lastfm_stat_last_refresh: String? = "",
         
         add_last_month: Bool = false,
         add_this_month: Bool = false,
         day_boundary: Int = 14,
         
         chart_range: LastFmRange = .overall,
         chart_limit: Int = 10){

        self.name = name
        self.uri = uri
        self.username = username
        
        self.type = type
        
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
        
        self.add_last_month = add_last_month
        self.add_this_month = add_this_month
        self.day_boundary = day_boundary
        
        self.chart_range = chart_range
        self.chart_limit = chart_limit
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
        do{
            username = try container.decode(String.self, forKey: .username)
        }catch {
            username = "NO USER"
            Logger.parse.warning("failed to parse username")
        }
            
        type = try container.decode(String.self, forKey: .type)
        
        do{
            description_overwrite = try container.decode(String.self, forKey: .description_overwrite)
        }catch {
        }
        
        do{
            description_suffix = try container.decode(String.self, forKey: .description_suffix)
        }catch {
        }
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
        
        do{
            include_library_tracks = try container.decode(Bool.self, forKey: .include_library_tracks)
        }catch {
            include_library_tracks = false
        }
        
        parts = try container.decode([String].self, forKey: .parts)
        playlist_references = try container.decode([String].self, forKey: .playlist_references)
        shuffle = try container.decode(Bool.self, forKey: .shuffle)
        
        do{
            sort = try container.decode(String.self, forKey: .sort)
        }catch {
            sort = "release_date"
        }
        
        do {
            add_last_month = try container.decode(Bool.self, forKey: .add_last_month)
        }catch {
            add_last_month = false
        }
        
        do {
            add_this_month = try container.decode(Bool.self, forKey: .add_this_month)
        }catch {
            add_this_month = false
        }
        
        do {
            day_boundary = try container.decode(Int.self, forKey: .day_boundary)
        }catch {
            day_boundary = 21
        }
        
        do{
            chart_range = try LastFmRange(rawValue: container.decode(String.self, forKey: .chart_range)) ?? LastFmRange.month
        }catch {
            chart_range = .halfyear
        }
     
        do{
            chart_limit = try container.decode(Int.self, forKey: .chart_limit)
        }catch {
            chart_limit = 50
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.uri, forKey: .uri)
        try container.encode(self.username, forKey: .username)
        
        try container.encode(self.type, forKey: .type)
        
        try container.encode(self.include_recommendations, forKey: .include_recommendations)
        try container.encode(self.recommendation_sample, forKey: .recommendation_sample)
        try container.encode(self.include_library_tracks, forKey: .include_library_tracks)
        
        try container.encode(self.parts, forKey: .parts)
        try container.encode(self.playlist_references, forKey: .playlist_references)
        try container.encode(self.shuffle, forKey: .shuffle)
        
        try container.encode(self.sort, forKey: .sort)
        try container.encode(self.description_overwrite, forKey: .description_overwrite)
        try container.encode(self.description_suffix, forKey: .description_suffix)
        
        try container.encode(self.last_updated, forKey: .last_updated)
        
        try container.encode(self.lastfm_stat_count, forKey: .lastfm_stat_count)
        try container.encode(self.lastfm_stat_album_count, forKey: .lastfm_stat_album_count)
        try container.encode(self.lastfm_stat_artist_count, forKey: .lastfm_stat_artist_count)
        
        try container.encode(self.lastfm_stat_percent, forKey: .lastfm_stat_percent)
        try container.encode(self.lastfm_stat_album_percent, forKey: .lastfm_stat_album_percent)
        try container.encode(self.lastfm_stat_artist_percent, forKey: .lastfm_stat_artist_percent)
        
        try container.encode(self.lastfm_stat_last_refresh, forKey: .lastfm_stat_last_refresh)
        
        try container.encode(self.add_last_month, forKey: .add_last_month)
        try container.encode(self.add_this_month, forKey: .add_this_month)
        try container.encode(self.day_boundary, forKey: .day_boundary)
        
        try container.encode(self.chart_range, forKey: .chart_range)
        try container.encode(self.chart_limit, forKey: .chart_limit)
    }
    
}

enum LastFmRange: String, Codable {
    case overall = "OVERALL"
    case week = "WEEK"
    case month = "MONTH"
    case quarter = "QUARTER"
    case halfyear = "HALFYEAR"
    case year = "YEAR"
}
