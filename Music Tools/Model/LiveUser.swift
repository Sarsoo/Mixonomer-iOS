//
//  LiveUser.swift
//  Music Tools
//
//  Created by Andy Pack on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation

class LiveUser: ObservableObject {
    var playlists: [Playlist]
    var tags: [Tag]
    
    init(playlists: [Playlist], tags: [Tag]) {
        self.playlists = playlists
        self.tags = tags
    }
}
