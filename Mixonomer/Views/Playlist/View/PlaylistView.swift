//
//  PlaylistView.swift
//  Mixonomer
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import ToastUI
import SwiftyJSON
import OSLog

struct PlaylistView: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @Binding var playlist: Playlist
    
    @State private var showingSheet = false
    @State private var isRefreshing = false
    
    // TOAST
    @State private var showingToast = false
    @State private var toastText = ""
    @State private var toastSuccess = true
    
    var body: some View {
        Form {
            
            if liveUser.lastfm_connected() {
                PlaylistStatsSection(playlist: $playlist, showingToast: $showingToast, toastText: $toastText, toastSuccess: $toastSuccess)
            }
            
            PlaylistOptionsSection(playlist: $playlist, showingSheet: $showingSheet)
            PlaylistInputSection(playlist: $playlist)
            
            Section(header: Text("Actions"),
                    footer: VStack(alignment: .leading) {
                        Text("Last Updated \(self.playlist.last_updated ?? "never")")
                        Text("Stats Updated \(self.playlist.lastfm_stat_last_refresh ?? "never")")
            }){
                Button(action: { self.runPlaylist() }) {
                    Text("Update")
                }
                
                Button(action: { self.openPlaylist() }) {
                    Text("Open")
                }
            }
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
        .navigationBarTitle(Text(playlist.name))
#if os(iOS)
        .refreshable {
            self.refreshPlaylist()
        }
#endif
    }
    
    func runPlaylist() {
        
        Logger.net.debug("running playlist from view: \(self.playlist.name)")
        
        let api = PlaylistApi.runPlaylist(name: playlist.name)
        RequestBuilder.buildRequest(apiRequest: api)
            .validate()
            .responseJSON{ response in
                
            if self.liveUser.check_network_response(response: response) {
                
                toastText = "Running!"
                toastSuccess = true
                showingToast = true
                
                Logger.net.debug("playlist run queued from view: \(self.playlist.name)")
                
            } else {
                
                toastText = "Run Request Failed"
                toastSuccess = false
                showingToast = true
                
                Logger.net.debug("playlist run request failed from view: \(self.playlist.name)")
            }
        }
    }
    
    func openPlaylist() {
        
        Logger.sys.debug("attempting to open \(self.playlist.link)")
        
        if let url = URL(string: self.playlist.link) {
            UIApplication.shared.open(url)
        }
    }
    
    func updatePlaylist(updates: JSON) {
        
        Logger.net.debug("updating playlist from view: \(self.playlist.name)")
        
        let api = PlaylistApi.updatePlaylist(name: playlist.name, updates: updates)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.check_network_response(response: response) {
                Logger.net.debug("updated playlist from view")
            } else {
                Logger.net.error("failed to update playlist from view")
            }
        }
    }
    
    func refreshPlaylist() {
        
        Logger.net.debug("Refreshing playlist: \(self.playlist.name)")
        
        let api = PlaylistApi.getPlaylist(name: self.playlist.name)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.check_network_response(response: response) {
                
                guard let data = response.data else {
                    Logger.net.error("failed to get playlist from net request")
                    return
                }
                
                self.playlist = PlaylistApi.fromJSON(playlist: data)!
                
                toastText = "Refreshed!"
                toastSuccess = true
                showingToast = true
                
                Logger.net.debug("Successfully refreshed playlist: \(self.playlist.name)")
                
            } else {
                
                Logger.net.error("request failed for get playlist")
             
                toastText = "Refresh Failed"
                toastSuccess = false
                showingToast = true
                
            }
            
            self.isRefreshing = false
        }
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlaylistView(playlist: .constant(
                Playlist(name: "playlist name",
                         username: "username",
                         lastfm_stat_percent: 30,
                         lastfm_stat_album_percent: 40,
                         lastfm_stat_artist_percent: 80
                        )
            ))
            .environmentObject(LiveUser.get_preview_user())
            PlaylistView(playlist: .constant(
                Playlist(name: "playlist name",
                         username: "username",
                         lastfm_stat_percent: 30,
                         lastfm_stat_album_percent: 40,
                         lastfm_stat_artist_percent: 80
                        )
            ))
            .environmentObject(LiveUser.get_preview_user_with_user())
        }
        
    }
}
