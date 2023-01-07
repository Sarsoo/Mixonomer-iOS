//
//  PlaylistInputSection.swift
//  Mixonomer
//
//  Created by Andy Pack on 07/01/2023.
//  Copyright © 2023 Sarsoo. All rights reserved.
//

import SwiftUI

struct PlaylistInputSection: View {
    
    @Binding var playlist: Playlist
    
    var body: some View {
        Section(header: Text("Inputs")){
            NavigationLink(destination: ManagedInputList(names: self.$playlist.playlist_references, playlist: self.$playlist)) {
                HStack {
                    Text("Managed Playlists")
                    Spacer()
                    Text("\(self.playlist.playlist_references.count)")
                        .foregroundColor(Color.gray)
                }
            }
            
            NavigationLink(destination: SpotInputList(names: self.$playlist.parts, playlist: self.$playlist)) {
                HStack {
                    Text("Spotify Playlists")
                    Spacer()
                    Text("\(self.playlist.parts.count)")
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}

struct PlaylistInputSection_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistInputSection(playlist: .constant(Playlist(name: "Test")))
    }
}
