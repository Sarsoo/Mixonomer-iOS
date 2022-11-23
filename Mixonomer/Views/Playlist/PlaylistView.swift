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
import SwiftUICharts
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
    
    var trackChartStyle: ChartStyle {
        get {
            let _style = ChartStyle(backgroundColor: .white, accentColor: Color(red: 0.4765, green: 0.5976, blue: 0.7578), gradientColor: GradientColors.bluPurpl, textColor: .black, legendTextColor: .gray)
            return _style
        }
    }
    
    var albumChartStyle: ChartStyle {
        get {
            let _style = ChartStyle(backgroundColor: .white, accentColor: Color(red: 0.6367, green: 0.2968, blue: 0.4648), gradientColor: GradientColors.bluPurpl, textColor: .black, legendTextColor: .gray)
            return _style
        }
    }
    
    var artistChartStyle: ChartStyle {
        get {
            let _style = ChartStyle(backgroundColor: .white, accentColor: Color(red: 0.3476, green: 0.5195, blue: 0.3359), gradientColor: GradientColors.bluPurpl, textColor: .black, legendTextColor: .gray)
            return _style
        }
    }
    
    var chartSize = CGSize(width:210, height:250);
    
    var body: some View {
        Form {
            
            if liveUser.lastfm_connected() {
            
                Section(header: Text("Stats")){
                    HStack {
                        Text("Track Count")
                        Spacer()
                        Text("\(self.playlist.lastfm_stat_count)")
                            .font(.title)
                            .foregroundColor(Color.gray)
                        Text("\(self.playlist.lastfm_stat_percent_str)")
                            .font(.body)
                            .foregroundColor(Color.gray)
                    }
                    HStack {
                        Text("Album Count")
                        Spacer()
                        Text("\(self.playlist.lastfm_stat_album_count)")
                            .font(.title)
                            .foregroundColor(Color.gray)
                        Text("\(self.playlist.lastfm_stat_album_percent_str)")
                            .font(.body)
                            .foregroundColor(Color.gray)
                    }
                    HStack {
                        Text("Artist Count")
                        Spacer()
                        Text("\(self.playlist.lastfm_stat_artist_count)")
                            .font(.title)
                            .foregroundColor(Color.gray)
                        Text("\(self.playlist.lastfm_stat_artist_percent_str)")
                            .font(.body)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        self.refreshStats()
                    }){
                        Text("Refresh")
                    }
                }
        
                ScrollView(.horizontal){
                    HStack {
                        Spacer()
                        PieChartView(
                            data: [Double(self.playlist.lastfm_stat_percent), Double(100 - self.playlist.lastfm_stat_percent)],
                            title: "Tracks",
                            legend:"Listening",
                            style: trackChartStyle,
                            form: chartSize)
                        Spacer(minLength: 20)
                        PieChartView(
                            data: [Double(self.playlist.lastfm_stat_album_percent), Double(100 - self.playlist.lastfm_stat_album_percent)],
                            title: "Albums",
                            legend:"Listening",
                            style: albumChartStyle,
                            form: chartSize)
                        Spacer(minLength: 20)
                        PieChartView(
                            data: [Double(self.playlist.lastfm_stat_artist_percent), Double(100 - self.playlist.lastfm_stat_artist_percent)],
                            title: "Artists",
                            legend:"Listening",
                            style: artistChartStyle,
                            form: chartSize)
                        Spacer()
                    }
                    .padding([.vertical], 20)
                    .padding([.horizontal], 10)
                }
                .listRowInsets(EdgeInsets())
            }
            
            Section(header: Text("Options")){
                Toggle(isOn: self.$playlist.include_recommendations) {
                    Text("Spotify Recommendations")
                }
                
                if self.playlist.include_recommendations {
                    Stepper(onIncrement: {
                        self.$playlist.recommendation_sample.wrappedValue += 1
                    },
                        onDecrement: {
                            if self.playlist.recommendation_sample > 0 {
                                self.$playlist.recommendation_sample.wrappedValue -= 1
                                
                            }
                    }){
                        Text("#:")
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.trailing)
                        Text("\(self.playlist.recommendation_sample)")
                            .multilineTextAlignment(.trailing)
                        
                    }
                }
                
                Toggle(isOn: self.$playlist.include_library_tracks) {
                    Text("Library Tracks")
                }
                
                Toggle(isOn: self.$playlist.shuffle) {
                    Text("Shuffle")
                }
                
                if playlist.type == "recents" {
                    Toggle(isOn: self.$playlist.add_this_month) {
                        Text("This Month")
                    }
                    
                    Toggle(isOn: self.$playlist.add_last_month) {
                        Text("Last Month")
                    }
                }
                
                if playlist.type == "fmchart" {
                    HStack {
                        Text("Chart Range")
                        Spacer()
                        Button(action: {
                            self.showingSheet = true
                            }) {
                                Text("\(self.playlist.chart_range.rawValue)")
                                .foregroundColor(Color.gray)
                        }.actionSheet(isPresented: $showingSheet) {
                            ActionSheet(title: Text("Chart range"),
                                        message: Text("Select time range for Last.fm chart"),
                                        buttons: [.default(Text("7 Days")),
                                                  .default(Text("1 Month")),
                                                  .default(Text("3 Months")),
                                                  .default(Text("6 Months")),
                                                  .default(Text("Year")),
                                                  .default(Text("Overall")),
                                                  .default(Text("Dismiss"))])
                        }
                    }
                }
            }
            Section(header: Text("Inputs")){
                NavigationLink(destination: ManagedInputList(names: self.$playlist.playlist_references, playlist: self.$playlist)) {
                    HStack {
                        Text("Managed Playlists")
                        Spacer()
                        Text("\(self.playlist.playlist_references.count)")
                            .foregroundColor(Color.gray)
                    }
                }
                
                NavigationLink(destination: SpotInputList(names: self.$playlist.parts, playlist: self.$playlist)) {
                    HStack {
                        Text("Spotify Playlists")
                        Spacer()
                        Text("\(self.playlist.parts.count)")
                            .foregroundColor(Color.gray)
                    }
                }
            }
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
        .refreshable {
            self.refreshPlaylist()
        }
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
    
    func refreshStats() {
        
        Logger.net.debug("refreshing playlist stats from view: \(self.playlist.name)")
        
        let api = PlaylistApi.refreshStats(name: playlist.name)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.check_network_response(response: response) {
                
                toastText = "Refreshing Stats!"
                toastSuccess = true
                showingToast = true
                
                Logger.net.debug("stat refresh queued from view: \(self.playlist.name)")
                
            } else {
             
                toastText = "Stat Refresh Failed"
                toastSuccess = false
                showingToast = true
                
                Logger.net.debug("stat refresh request failed from view: \(self.playlist.name)")
                
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
            .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
            PlaylistView(playlist: .constant(
                Playlist(name: "playlist name",
                         username: "username",
                         lastfm_stat_percent: 30,
                         lastfm_stat_album_percent: 40,
                         lastfm_stat_artist_percent: 80
                        )
            ))
            .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false, user: User()))
        }
        
    }
}
