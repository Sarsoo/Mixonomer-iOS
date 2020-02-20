//
//  Tag.swift
//  Music Tools
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

class Tag: Identifiable, Equatable {
    
    //MARK: Properties
    
    var tag_id: String
    var name: String
    var username: String
    
    var tracks: [JSON]
    var albums: [JSON]
    var artists: [JSON]
    
    var count: Int
    var proportion: Double
    var total_user_scrobbles: Int
    
    var last_updated: String
    
    //MARK: Initialization
    
    init(tag_id: String,
         name: String,
         username: String,
         
         tracks: [JSON],
         albums: [JSON],
         artists: [JSON],
         
         count: Int,
         proportion: Double,
         total_user_scrobbles: Int,
        
         last_updated: String){
        
        self.tag_id = tag_id
        self.name = name
        self.username = username
        
        self.tracks = tracks
        self.albums = albums
        self.artists = artists
        
        self.count = count
        self.proportion = proportion
        self.total_user_scrobbles = total_user_scrobbles
        
        self.last_updated = last_updated
    }
    
    static func fromDict(dictionary: JSON) -> Tag {
        return Tag(tag_id: dictionary["tag_id"].stringValue,
                   name: dictionary["name"].stringValue,
                   username: dictionary["username"].stringValue,
                   
                   tracks: dictionary["tracks"].arrayValue,
                   albums: dictionary["albums"].arrayValue,
                   artists: dictionary["artists"].arrayValue,
                   
                   count: dictionary["count"].intValue,
                   proportion: dictionary["proportion"].doubleValue,
                   total_user_scrobbles: dictionary["total_user_scrobbles"].intValue,
                   
                   last_updated: dictionary["last_updated"].stringValue)
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.tag_id == rhs.tag_id
//            && lhs.username == rhs.username
    }
    
}
