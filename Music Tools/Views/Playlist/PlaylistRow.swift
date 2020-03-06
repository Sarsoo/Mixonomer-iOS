//
//  PlaylistRow.swift
//  Music Tools
//
//  Created by Andy Pack on 17/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct PlaylistRow: View {
    @Binding var playlist: Playlist
    
    var body: some View {
        NavigationLink(destination: PlaylistView(playlist: $playlist)){
            HStack {
                Text(playlist.name)
                    .contextMenu {
                        
                        // run force touch
                        Button(action: {
                            let api = PlaylistApi.runPlaylist(name: self.playlist.name)
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                            }
                        }) {
                            Text("Refresh")
                            Image(systemName: "arrow.clockwise.circle")
                        }
                        
                        // open force touch
                        Button(action: {
                            if let url = URL(string: self.playlist.link) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Open")
                            Image(systemName: "arrowshape.turn.up.right.circle")
                        }
                }
            }
        }
    }
}

struct PlaylistRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(playlist: .constant(
            Playlist(name: "playlist name", username: "username")
        ))
    }
}
