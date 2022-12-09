//
//  PlaylistList.swift
//  Mixonomer
//
//  Created by Andy Pack on 25/04/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import ToastUI

struct PlaylistList: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @State private var showAdd = false // State for showing add modal view
    
    @State private var showingToast = false
    @State private var toastText = ""
    @State private var toastSuccess = true
    
    var body: some View {
        NavigationView {
            
            List{
                if liveUser.user.spotify_linked == false {
                    Text("Spotify isn't linked, login to the web client to pair")
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://mixonomer.sarsoo.xyz/")!)
                    }) {
                        Text("Go-to Mixonomer Web")
                            .foregroundColor(.blue)
                    }
                }
                else if liveUser.playlists.count > 0 {
                    ForEach(liveUser.playlists.indices, id:\.self) { idx in
                        PlaylistRow(playlist: self.$liveUser.playlists[idx])
                    }
                    .onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            let api = PlaylistApi.deletePlaylist(name: self.liveUser.playlists[index].name)
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                                if self.liveUser.check_network_response(response: response) {
                                    
                                } else {
                                    
                                }
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
                self.liveUser.refresh_playlists(onSuccess: {
                    
                    toastText = "Refreshed!"
                    toastSuccess = true
                    showingToast = true
                    
                }, onFailure: {
                    
                    toastText = "Refresh Failed"
                    toastSuccess = false
                    showingToast = true
                    
                })
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
            .toast(isPresented: $showingToast, dismissAfter: 1.0){
                
                if toastSuccess {
                    ToastView(toastText)
                        .toastViewStyle(.success)
                }
                else {
                    ToastView(toastText)
                        .toastViewStyle(.failure)
                }
            }
            .toastDimmedBackground(false)
        }
    }
}

struct PlaylistList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlaylistList()
                .environmentObject(LiveUser.get_preview_user())
            PlaylistList()
                .environmentObject(LiveUser.get_preview_user_with_user())
        }
    }
}
