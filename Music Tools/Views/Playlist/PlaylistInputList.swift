//
//  PlaylistInputList.swift
//  Music Tools
//
//  Created by Andy Pack on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct Name: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct PlaylistInputList: View {
    
    var names: Array<String> = []
    var nameType: String
    
    init(names: Array<String>, nameType: String){
        self.nameType = nameType
        self.names = names.sorted(by: { $0.lowercased() < $1.lowercased() })
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
        .navigationBarItems(trailing:
            Button(
                action: {  },
                label: { Image(systemName: "plus.circle") }
            )
        )
    }
}

struct PlaylistInputList_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistInputList(names: [
            "name"
        ], nameType: "Spotify Playlists")
    }
}
