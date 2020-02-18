//
//  RootView.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import Alamofire

struct RootView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            NavigationView {
                List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                    Text("Playlist")
                        .font(.title)
                        
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
        let net: BasicAuthNetwork = BasicAuthNetwork(username: "", password: "")
        net.authedRequest(path: "api/playlist",
                   method: Alamofire.HTTPMethod.get,
                   parameters: ["name": ""],
                   encoder: nil,
                   headers: nil)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
