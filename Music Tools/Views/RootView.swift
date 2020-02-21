//
//  RootView.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct RootView: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @State private var selection = 0 // Tab view selection
    @State private var playlists: Array<Playlist> = [] // Network pulled playlists
    @State private var tags: Array<Tag> = [] // Network pulled tags
    
    @State private var showAdd = false // State for showing add modal view
    
    @State private var justDeletedPlaylists: Array<Playlist> = [] // Cache of recently deleted playlists for removing from next net request
    @State private var justDeletedTags: Array<Tag> = []
    
    // refresh playlist list on interval
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
 
    var body: some View {
        TabView   {
            
            // PLAYLISTS
            NavigationView {
                List{
                    ForEach(playlists) { playlist in
                        PlaylistRow(playlist: playlist)
                    }
                    .onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            // add to recently deleted playlist cache
                            self.justDeletedPlaylists.append(self.playlists[index])
                            
                            let api = PlaylistApi.deletePlaylist(name: self.playlists[index].name)
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                            }
                        }
                        
                        self.playlists.remove(atOffsets: indexSet)
                    }
                }
                .navigationBarTitle(Text("Playlists").font(.title))
                    
                    // add playlist button
                .navigationBarItems(trailing:
                    Button(
                        action: { self.showAdd = true },
                        label: { Text("Add") }
                    ).sheet(isPresented: $showAdd) {
                        AddPlaylistSheet(state: self.$showAdd, playlists: self.$playlists)
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
                    ForEach(tags) { tag in
                        TagRow(tag: tag)
                    }
                    .onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            // add to recently deleted playlist cache
                            self.justDeletedTags.append(self.tags[index])
                            
                            let api = TagApi.deleteTag(tag_id: self.tags[index].tag_id)
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                            }
                        }
                        
                        self.tags.remove(atOffsets: indexSet)
                    }
                }
                .navigationBarTitle(Text("Tags").font(.title))
                    
                    // add playlist button
                .navigationBarItems(trailing:
                    Button(
                        action: { self.showAdd = true },
                        label: { Text("Add") }
                    ).sheet(isPresented: $showAdd) {
                        AddPlaylistSheet(state: self.$showAdd, playlists: self.$playlists)
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
            .onReceive(timer) { _ in
                self.fetch()
            }
        }.onAppear {
            self.fetch()
        }
    }
    
    private func fetch() {
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
                    Playlist.fromDict(dictionary: dict)
                })
                    // sort
                .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                    // filter playlists for those recently deleted
                .filter { (rxPlaylist) -> Bool in
                    
                    var deleted = false
                    for playlist in self.justDeletedPlaylists {
                        if playlist == rxPlaylist {
                            deleted = true
                        }
                    }
                    return !deleted
            }
            // clear cache of recently deleted playlists
            self.justDeletedPlaylists = []
            
            // update state
            self.liveUser.playlists = playlists
            self.playlists = self.liveUser.playlists
        }
        //TODO: do better error checking
        
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
                    // filter playlists for those recently deleted
                .filter { (rxTag) -> Bool in
                    
                    var deleted = false
                    for tag in self.justDeletedTags {
                        if tag == rxTag {
                            deleted = true
                        }
                    }
                    return !deleted
            }
            // clear cache of recently deleted playlists
            self.justDeletedTags = []
            
            // update state
            self.liveUser.tags = tags
            self.tags = self.liveUser.tags
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
