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
    @State private var selection = 0
    @State private var playlists: Array<Playlist> = []
 
    var body: some View {
        TabView(selection: $selection){
            NavigationView {
                List(playlists) { playlist in
                    PlaylistRow(playlist: playlist)
                }
                .navigationBarTitle(Text("Playlists").font(.title))
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
            
            self.playlists = json["playlists"].arrayValue.map({ dict in
                Playlist.fromDict(dictionary: dict)
            }).sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
