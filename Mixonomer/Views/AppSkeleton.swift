//
//  AppSkeleton.swift
//  Mixonomer
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct AppSkeleton: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @State private var selection = 0 // Tab view selection
    
    var body: some View {
        TabView {
            
            PlaylistList()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("Playlists")
                    }
                }
                .tag(0)
            
            if liveUser.lastfm_connected() {
                
                TagList()
                    .tabItem {
                        VStack {
                            Image(systemName: "tag")
                            Text("Tags")
                        }
                    }
                    .tag(1)
            }
            
            if let user = liveUser.user {
                if user.type == .admin {
                    AdminList()
                        .tabItem( {
                            VStack {
                                Image(systemName: "person.badge.key.fill")
                                Text("Admin")
                            }
                        })
                        .tag(2)
                }
            }
            
            SettingsList()
                .tabItem {
                    VStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Settings")
                    }
                }
                .tag(3)
            
        }.onAppear {
            self.fetchAll()
        }
    }
    
    private func fetchAll() {
        self.liveUser.refresh_user()
        self.liveUser.refresh_playlists()
        self.liveUser.refresh_tags()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        AppSkeleton()
            .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
    }
}
