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
    
    init(playlists: [Playlist], tags: [Tag]) {
        self.playlists = playlists
        self.tags = tags
    }
    
    func updatePlaylist(playlistIn: Playlist) {
        guard let index = self.playlists.firstIndex(of: playlistIn) else {
            fatalError("\(playlistIn) not found")
        }
        self.playlists[index] = playlistIn
    }
}
