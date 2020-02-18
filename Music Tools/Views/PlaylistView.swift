//
//  PlaylistView.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct PlaylistView: View {
    var playlist: Playlist
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(playlist.name)
                .font(.largeTitle)
                .multilineTextAlignment(.leading)
            Text(playlist.username)
                .foregroundColor(Color.gray)
            Image("PlaylistCoverImage")
                    .resizable()
                    .frame(width: 200.0, height: 200.0, alignment: .trailing)
                    .cornerRadius(18)
                    .padding(.bottom, 20)
            
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                Text("Spotify Recommendations")
            }
            
            Stepper(value: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(4)/*@END_MENU_TOKEN@*/, in: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Range@*/1...10/*@END_MENU_TOKEN@*/){
                Text("#:")
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.trailing)
                    .padding(.leading, 20)
                Text("100")
                    .multilineTextAlignment(.trailing)
                
            }
            
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                Text("Library Tracks")
            }
            
            EditButton()
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(playlist:
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
