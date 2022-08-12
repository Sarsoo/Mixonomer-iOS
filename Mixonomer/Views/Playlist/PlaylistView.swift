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

struct PlaylistView: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @Binding var playlist: Playlist
    
    @State private var showingSheet = false
    @State private var isRefreshing = false
    
    // TOAST
    @State private var showingToast = false
    @State private var toastText = ""
    @State private var toastSuccess = true
    
    var chartStyle: ChartStyle {
        get {
            let _style = ChartStyle(backgroundColor: .white, accentColor: .red, gradientColor: GradientColors.bluPurpl, textColor: .black, legendTextColor: .gray)
            return _style
        }
    }
    
    var chartSize = CGSize(width:210, height:250);
    
    var body: some View {
        Form {
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
                        style: chartStyle,
                        form: chartSize)
                    Spacer(minLength: 20)
                    PieChartView(
                        data: [Double(self.playlist.lastfm_stat_album_percent), Double(100 - self.playlist.lastfm_stat_album_percent)],
                        title: "Albums",
                        legend:"Listening",
                        style: chartStyle,
                        form: chartSize)
                    Spacer(minLength: 20)
                    PieChartView(
                        data: [Double(self.playlist.lastfm_stat_artist_percent), Double(100 - self.playlist.lastfm_stat_artist_percent)],
                        title: "Artists",
                        legend:"Listening",
                        style: chartStyle,
                        form: chartSize)
                    Spacer()
                }
                .padding([.vertical], 20)
                .padding([.horizontal], 10)
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
                NavigationLink(destination: PlaylistInputList(names: self.$playlist.playlist_references, nameType: "Managed Playlists")) {
                    HStack {
                        Text("Managed Playlists")
                        Spacer()
                        Text("\(self.playlist.playlist_references.count)")
                            .foregroundColor(Color.gray)
                    }
                }
                
                NavigationLink(destination: PlaylistInputList(names: self.$playlist.parts, nameType: "Spotify Playlists")) {
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
        let api = PlaylistApi.runPlaylist(name: playlist.name)
        RequestBuilder.buildRequest(apiRequest: api)
            .validate()
            .responseJSON{ response in
                
            if self.liveUser.checkNetworkResponse(response: response) {
                
                toastText = "Running!"
                toastSuccess = true
                showingToast = true
                
            } else {
                
                toastText = "Run Request Failed"
                toastSuccess = false
                showingToast = true
            }
        }
    }
    
    func refreshStats() {
        let api = PlaylistApi.refreshStats(name: playlist.name)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.checkNetworkResponse(response: response) {
                
                toastText = "Refreshing Stats!"
                toastSuccess = true
                showingToast = true
                
            } else {
             
                toastText = "Stat Refresh Failed"
                toastSuccess = false
                showingToast = true
                
            }
        }
    }
    
    func openPlaylist() {
        if let url = URL(string: self.playlist.link) {
            UIApplication.shared.open(url)
        }
    }
    
    func updatePlaylist(updates: JSON) {
        let api = PlaylistApi.updatePlaylist(name: playlist.name, updates: updates)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.checkNetworkResponse(response: response) {
                debugPrint("success")
            } else {
                debugPrint("error")
            }
        }
        //TODO: do better error checking
    }
    
    func refreshPlaylist() {
        let api = PlaylistApi.getPlaylist(name: self.playlist.name)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.checkNetworkResponse(response: response) {
                
                guard let data = response.data else {
                    fatalError("error getting playlist")
                }
                
                self.playlist = PlaylistApi.fromJSON(playlist: data)!
                
                toastText = "Refreshed!"
                toastSuccess = true
                showingToast = true
                
            } else {
             
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
        PlaylistView(playlist: .constant(
            Playlist(name: "playlist name",
                     username: "username",
                     lastfm_stat_percent: 30,
                     lastfm_stat_album_percent: 40,
                     lastfm_stat_artist_percent: 80
                    )
        ))
        .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
        
    }
}
