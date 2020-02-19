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
    
    @State private var selection = 0
    @State private var playlists: Array<Playlist> = []
    
    @State private var isLoading = true
    @State private var showAdd = false
    
    @State private var onClose = onSheetClose
    
    @State private var justDeleted: Array<Playlist> = []
        
    func onSheetClose() {
        self.fetch()
        return
    }
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
 
    var body: some View {
        TabView   {
            NavigationView {
                List{
                    ForEach(playlists) { playlist in
                        PlaylistRow(playlist: playlist)
                    }
                    .onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            self.justDeleted.append(self.playlists[index])
                            
                            let api = PlaylistApi.deletePlaylist(name: self.playlists[index].name)
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                            }
                        }
                        
                        self.playlists.remove(atOffsets: indexSet)
                    }
                }
                .navigationBarTitle(Text("Playlists").font(.title))
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
            //
            //
            NavigationView {
                List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                    Text("Tag")
                        .font(.title)
                        
                }
                .navigationBarTitle(Text("Tags"))
            }
            .tabItem {
                VStack {
                    Image(systemName: "sum")
                    Text("Tags")
                }
            }
            .tag(1)
            //
            //
            Text("Settings")
            .font(.title)
            .tabItem {
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
            
            let playlists = json["playlists"].arrayValue.map({ dict in
                Playlist.fromDict(dictionary: dict)
            }).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                .filter { (rxPlaylist) -> Bool in
                    
                    var deleted = false
                    for playlist in self.justDeleted {
                        if playlist == rxPlaylist {
                            deleted = true
                        }
                    }
                    return !deleted
            }
            self.justDeleted = []
            
            self.liveUser.playlists = playlists
            self.playlists = self.liveUser.playlists
        }
        //TODO: do better error checking
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
