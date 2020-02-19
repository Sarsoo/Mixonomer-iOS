//
//  PlaylistInputList.swift
//  Music Tools
//
//  Created by Andy Pack on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct Name: Identifiable {
    var id = UUID()
    var name: String
}

struct PlaylistInputList: View {
    
    var names: Array<Name> = []
    var nameType: String
    
    init(names: Array<String>, nameType: String){
        self.nameType = nameType
        self.names = names.map { (name) -> Name in
            return Name(name: name)
        }.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        
    }
    
    var body: some View {
        return List(names) { name in
            Text(name.name)
        }
        .navigationBarTitle(Text(nameType))
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
