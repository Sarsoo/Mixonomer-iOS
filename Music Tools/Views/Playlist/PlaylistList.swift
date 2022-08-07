//
//  PlaylistList.swift
//  Mixonomer
//
//  Created by Andy Pack on 25/04/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct PlaylistList: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @State private var showAdd = false // State for showing add modal view
    
    var body: some View {
        NavigationView {
            List{
                if(liveUser.playlists.count > 0){
                    ForEach(liveUser.playlists.indices, id:\.self) { idx in
                        PlaylistRow(playlist: self.$liveUser.playlists[idx])
                    }
                    .onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            let api = PlaylistApi.deletePlaylist(name: self.liveUser.playlists[index].name)
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                            } 
                        }
                        
                        self.liveUser.playlists.remove(atOffsets: indexSet)
                    }
                }else {
                    Text("No Playlists")
                }
            }
            .refreshable
            {
                self.liveUser.refreshPlaylists()
            }
            .navigationBarTitle(Text("Playlists 📻"))
            .navigationBarItems(trailing:
                Button(
                    action: { self.showAdd = true },
                    label: { Text("Add") }
                ).sheet(isPresented: $showAdd) {
                    AddPlaylistSheet(playlists: self.$liveUser.playlists, username: self.$liveUser.username)
                }
            )
        }
    }
}

struct PlaylistList_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistList()
    }
}
