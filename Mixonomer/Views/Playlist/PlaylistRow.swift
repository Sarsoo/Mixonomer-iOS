//
//  PlaylistRow.swift
//  Mixonomer
//
//  Created by Andy Pack on 17/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct PlaylistRow: View {
    
    @Binding var playlist: Playlist
    @State private var showingNetworkError = false
    
    var body: some View {
        NavigationLink(destination: PlaylistView(playlist: $playlist)){
            HStack {
                Text(playlist.name)
                if playlist.lastfm_stat_count > 0 {
                    Spacer()
                    Text("\(playlist.lastfm_stat_count)")
                        .foregroundColor(.gray)
                }
            }.contextMenu {
                Button(action: {
                    let api = PlaylistApi.runPlaylist(name: self.playlist.name)
                    RequestBuilder.buildRequest(apiRequest: api)
                        .validate()
                        .responseJSON{ response in
                            switch response.result {
                            case .success:
                                break
                            case .failure:
                                self.showingNetworkError = true
                            }
                    }
                }) {
                    Text("Refresh")
                    Image(systemName: "arrow.clockwise.circle")
                }
                Button(action: {
                    if let url = URL(string: self.playlist.link) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Open")
                    Image(systemName: "arrowshape.turn.up.right.circle")
                }
            }.alert(isPresented: $showingNetworkError) {
                Alert(title: Text("Network Error"),
                      message: Text("Could not refresh playlist"))
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
