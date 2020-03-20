//
//  RootView.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh
import Alamofire
import SwiftyJSON

struct RootView: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @State private var selection = 0 // Tab view selection
    
    @State private var showAdd = false // State for showing add modal view
    
    var body: some View {
        TabView   {
            
            // PLAYLISTS
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
                        HStack {
                            Text("No Playlists")
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }
                .pullToRefresh(isShowing: self.$liveUser.isRefreshingPlaylists) {
                    self.liveUser.refreshPlaylists()
                }
                .navigationBarTitle(Text("Playlists").font(.title))
                    
                    // add playlist button
                .navigationBarItems(trailing:
                    Button(
                        action: { self.showAdd = true },
                        label: { Text("Add") }
                    ).sheet(isPresented: $showAdd) {
                        AddPlaylistSheet(playlists: self.$liveUser.playlists, username: self.$liveUser.username)
                    }
                )
            }
            .tabItem {
                VStack {
                    Image(systemName: "music.note.list")
                    Text("Playlists")
                }
            }
            .tag(0)
            
            // TAGS
            NavigationView {
                List{
                    if(liveUser.tags.count > 0) {
                        ForEach(liveUser.tags.indices, id:\.self) { idx in
                            TagRow(tag: self.$liveUser.tags[idx])
                        }
                        .onDelete { indexSet in
                            
                            indexSet.forEach { index in
                                let api = TagApi.deleteTag(tag_id: self.liveUser.tags[index].tag_id)
                                RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                    
                                }
                            }
                            
                            self.liveUser.tags.remove(atOffsets: indexSet)
                        }
                    } else {
                        HStack {
                            Text("No Tags")
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }
                .pullToRefresh(isShowing: self.$liveUser.isRefreshingTags) {
                    self.liveUser.refreshTags()
                }
                .navigationBarTitle(Text("Tags").font(.title))
                    
                    // add playlist button
                .navigationBarItems(trailing:
                    Button(
                        action: { self.showAdd = true },
                        label: { Text("Add") }
                    ).sheet(isPresented: $showAdd) {
                        AddTagSheet(tags: self.$liveUser.tags, username: self.$liveUser.username)
                    }
                )
            }
            .tabItem {
                VStack {
                    Image(systemName: "sum")
                    Text("Tags")
                }
            }
            .tag(1)
            
            // SETTINGS
            NavigationView {
                SettingsList()
                .navigationBarTitle(Text("Settings").font(.title))
            }.tabItem {
                VStack {
                    Image(systemName: "slider.horizontal.3")
                    Text("Settings")
                }
            }
            .tag(2)
        }.onAppear {
            self.fetchAll()
        }
    }
    
    private func fetchAll() {
        self.liveUser.refreshPlaylists()
        self.liveUser.refreshTags()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
