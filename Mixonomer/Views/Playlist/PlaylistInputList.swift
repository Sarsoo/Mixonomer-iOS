//
//  PlaylistInputList.swift
//  Mixonomer
//
//  Created by Andy Pack on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct Name: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

enum PlaylistInputType {
    case MixonomerPlaylists
    case SpotifyPlaylists
}

struct PlaylistInputList: View {
    
    @Binding var names: [String]
    var nameType: String
    var type: PlaylistInputType
    
    init(names: Binding<[String]>, nameType: String, type: PlaylistInputType){
        self.nameType = nameType
        self._names = names
        self.type = type
    }
    
    var body: some View {
        List{
            Section(header: Image(systemName: "music.note")){ // Weird? added empty header as list renders with space for header then jumps up, not nice
                if self.names.count > 0 {
                    ForEach(self.names, id: \.self){ name in
                        Text(name)
                    }
                }else {
                    HStack {
                        Text("No Playlists")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
        }
//        .id(UUID())
        .navigationBarTitle(nameType)
//        .navigationBarItems(trailing:
//            Button(
//                action: {
//                    
//                },
//                label: { Image(systemName: "plus.circle") }
//            )
//        )
    }
}

struct PlaylistInputList_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistInputList(names: .constant([
            "name"
        ]), nameType: "Spotify Playlists", type: .MixonomerPlaylists)
    }
}
