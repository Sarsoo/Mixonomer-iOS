//
//  LiveUser.swift
//  Music Tools
//
//  Created by Andy Pack on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation

class LiveUser: ObservableObject {
    
    @Published var playlists: [Playlist]
    @Published var tags: [Tag]
    @Published var username: String
    
    init(playlists: [Playlist], tags: [Tag], username: String) {
        self.playlists = playlists
        self.tags = tags
        self.username = username
    }
    
    func updatePlaylist(playlistIn: Playlist) {
        guard let index = self.playlists.firstIndex(of: playlistIn) else {
            fatalError("\(playlistIn) not found")
        }
        self.playlists[index] = playlistIn
    }
}
