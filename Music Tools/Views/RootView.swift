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
    
    @State private var isRefreshingPlaylists = false
    @State private var isRefreshingTags = false
 
    var body: some View {
        TabView   {
            
            // PLAYLISTS
            NavigationView {
                List{
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
                }
                .pullToRefresh(isShowing: $isRefreshingPlaylists) {
                    self.refreshPlaylists()
                }
                .navigationBarTitle(Text("Playlists").font(.title))
                    
                    // add playlist button
                .navigationBarItems(trailing:
                    Button(
                        action: { self.showAdd = true },
                        label: { Text("Add") }
                    ).sheet(isPresented: $showAdd) {
                        AddPlaylistSheet(state: self.$showAdd, playlists: self.$liveUser.playlists, username: self.$liveUser.username)
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
                }
                .pullToRefresh(isShowing: $isRefreshingTags) {
                    self.refreshTags()
                }
                .navigationBarTitle(Text("Tags").font(.title))
                    
                    // add playlist button
                .navigationBarItems(trailing:
                    Button(
                        action: { self.showAdd = true },
                        label: { Text("Add") }
                    ).sheet(isPresented: $showAdd) {
                        AddTagSheet(state: self.$showAdd, tags: self.$liveUser.tags, username: self.$liveUser.username)
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
        refreshPlaylists()
        refreshTags()
    }
    
    public func refreshPlaylists() {
        let api = PlaylistApi.getPlaylists
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            guard let data = response.data else {
                fatalError("error getting playlists")
            }
            
            guard let json = try? JSON(data: data) else {
                fatalError("error parsing reponse")
            }
            
            let playlists = json["playlists"].arrayValue
                    // parse playlists
                .map({ dict in
                    Playlist.fromDict(dictionary: dict)!
                })
                    // sort
                .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            
            // update state
            self.liveUser.playlists = playlists
            self.isRefreshingPlaylists = false
        }
        //TODO: do better error checking
    }
    
    public func refreshTags() {
        let tagApi = TagApi.getTags
        RequestBuilder.buildRequest(apiRequest: tagApi).responseJSON{ response in
            
            guard let data = response.data else {
                fatalError("error getting playlists")
            }
            
            guard let json = try? JSON(data: data) else {
                fatalError("error parsing reponse")
            }
            
            let tags = json["tags"].arrayValue
                    // parse playlists
                .map({ dict in
                    Tag.fromDict(dictionary: dict)
                })
                    // sort
                .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            
            // update state
            self.liveUser.tags = tags
            self.isRefreshingTags = false
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
