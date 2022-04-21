//
//  AppSkeleton.swift
//  Music Tools
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
            
            TagList()
                .tabItem {
                    VStack {
                        Image(systemName: "tag")
                        Text("Tags")
                    }
                }
                .tag(1)
            
            SettingsList()
                .tabItem {
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
        AppSkeleton()
    }
}
