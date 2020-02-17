//
//  PlaylistRow.swift
//  Music Tools
//
//  Created by Ellie McCarthy on 17/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct PlaylistRow: View {
    var playlist: Playlist
    
    var body: some View {
        HStack {
            Text(playlist.name)
            Spacer()
        }
    }
}

struct PlaylistRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistRow(playlist:
            Playlist(name: "playlist name",
            uri: "uri",
            username: "username",
            
            include_recommendations: true,
            recommendation_sample: 5,
            include_library_tracks: true,
            
            parts: ["name"],
            playlist_references: ["ref name"],
            
            shuffle: true)
        )
    }
}
