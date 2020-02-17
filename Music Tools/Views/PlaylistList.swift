//
//  SwiftUIView.swift
//  Music Tools
//
//  Created by Ellie McCarthy on 17/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct PlaylistList: View {
    var playlists: Array<Playlist>
    
    var body: some View {
        List(playlists) { playlist in
            PlaylistRow(playlist: playlist)
        }
    }
}

struct PlaylistList_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistList(playlists:
            [
                Playlist(name: "playlist name",
                uri: "uri",
                username: "username",
                
                include_recommendations: true,
                recommendation_sample: 5,
                include_library_tracks: true,
                
                parts: ["name"],
                playlist_references: ["ref name"],
                
                shuffle: true)
            ]
        )
    }
}
