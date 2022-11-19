//
//  ManagedInputList.swift
//  Mixonomer
//
//  Created by Andy Pack on 19/11/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import SwiftUI

struct ManagedInputList: View {
    @EnvironmentObject var liveUser: LiveUser
    
    @Binding var playlist: Playlist
    @Binding var names: [String]
    
    @State var addName: String = ""
    
    @State private var addAlertShowing = false
    
    init(names: Binding<[String]>, playlist: Binding<Playlist>){
        self._names = names
        self._playlist = playlist
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
        .navigationBarTitle("Managed Playlists")
    }
}

struct ManagedInputList_Previews: PreviewProvider {
    static var previews: some View {
        ManagedInputList(names: .constant([
            "name"
        ]), playlist: .constant(Playlist(name: "Name")))
    }
}
