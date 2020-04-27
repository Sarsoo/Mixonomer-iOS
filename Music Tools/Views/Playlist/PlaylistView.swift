//
//  PlaylistView.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh
import SwiftyJSON
import SwiftUICharts

struct PlaylistView: View {
    
    @Binding var playlist: Playlist
    
    @State private var this_month: Bool = false
    @State private var last_month: Bool = false
    @State private var chart_range: LastFmRange = .overall
    @State private var chart_limit: Int = 0
    
    @State private var showingSheet = false
    @State private var isRefreshing = false
    @State private var showingNetworkError = false
    
    var chartStyle: ChartStyle {
        get {
            let _style = ChartStyle(backgroundColor: .white, accentColor: .red, gradientColor: GradientColors.bluPurpl, textColor: .black, legendTextColor: .gray)
            return _style
        }
    }
    
    var body: some View {
        List {
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
            
            VStack {
                HStack {
                    Spacer()
                    PieChartView(
                        data: [Double(self.playlist.lastfm_stat_percent), Double(100 - self.playlist.lastfm_stat_percent)],
                        title: "Tracks",
                        legend:"Listening",
                        style: chartStyle,
                        form: ChartForm.medium)
                    PieChartView(
                        data: [Double(self.playlist.lastfm_stat_album_percent), Double(100 - self.playlist.lastfm_stat_album_percent)],
                        title: "Albums",
                        legend:"Listening",
                        style: chartStyle,
                        form: ChartForm.medium)
                    Spacer()
                }
                PieChartView(
                    data: [Double(self.playlist.lastfm_stat_artist_percent), Double(100 - self.playlist.lastfm_stat_artist_percent)],
                    title: "Artists",
                    legend:"Listening",
                    style: chartStyle,
                    form: ChartForm.medium)
            }
            
            Section(header: Text("Options")){
                Toggle(isOn: self.$playlist.include_recommendations) {
                    Text("Spotify Recommendations")
                }
                
                if self.playlist.include_recommendations {
                    Stepper(onIncrement: {
                        self.$playlist.recommendation_sample.wrappedValue += 1
                        self.updatePlaylist(updates: JSON(["recommendation_sample": self.playlist.recommendation_sample]))
                    },
                            onDecrement: {
                        self.$playlist.recommendation_sample.wrappedValue -= 1
                        self.updatePlaylist(updates: JSON(["recommendation_sample": self.playlist.recommendation_sample]))
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
                
                if playlist is RecentsPlaylist {
                    Toggle(isOn: $this_month) {
                        Text("This Month")
                    }
                    
                    Toggle(isOn: $last_month) {
                        Text("Last Month")
                    }
                }
                
                if playlist is LastFMChartPlaylist {
                    HStack {
                        Text("Chart Range")
                        Spacer()
                        Button(action: {
                            self.showingSheet = true
                            }) {
                                Text("\(self.chart_range.rawValue)")
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
            
            // alert seems to need to be within list root element
            // else weird crash on half drag back
            .alert(isPresented: $showingNetworkError) {
                Alert(title: Text("Network Error"),
                      message: Text("Could not refresh playlist"))
            }
            
        }.listStyle(GroupedListStyle())
        .pullToRefresh(isShowing: $isRefreshing) {
            self.refreshPlaylist()
        }
        .navigationBarTitle(Text(playlist.name))
        .onAppear {
            
            // TODO are these binding properly?
            if let playlist = self.playlist as? RecentsPlaylist {
                self.$this_month.wrappedValue = playlist.add_this_month
                self.$last_month.wrappedValue = playlist.add_last_month
            }

            if let playlist = self.playlist as? LastFMChartPlaylist {
                self.$chart_range.wrappedValue = playlist.chart_range
                self.$chart_limit.wrappedValue = playlist.chart_limit
            }
        }
    }
    
    func changeChartRange(newRange: LastFmRange) {
        self.chart_range = newRange
//        self.updatePlaylist(["chart_range": newRange.rawValue])
        //TODO: are enums wrong by the time they're here? not sure api will accept it now
        //TODO: fix downcasting local playlist object to change state
    }
    
    func runPlaylist() {
        let api = PlaylistApi.runPlaylist(name: playlist.name)
        RequestBuilder.buildRequest(apiRequest: api)
            .validate()
            .responseJSON{ response in
                switch response.result {
                case .success:
                    break
                case .failure:
                    self.showingNetworkError = true
                }
        }
        //TODO: do better error checking
    }
    
    func refreshStats() {
        let api = PlaylistApi.refreshStats(name: playlist.name)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
        }
        //TODO: do better error checking
    }
    
    func openPlaylist() {
        if let url = URL(string: self.playlist.link) {
            UIApplication.shared.open(url)
        }
    }
    
    func updatePlaylist(updates: JSON) {
        let api = PlaylistApi.updatePlaylist(name: playlist.name, updates: updates)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            switch response.result {
            case .success:
                debugPrint("success")
            case .failure:
                debugPrint("error")
            }
        }
        //TODO: do better error checking
    }
    
    func refreshPlaylist() {
        let api = PlaylistApi.getPlaylist(name: self.playlist.name)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            guard let data = response.data else {
                fatalError("error getting playlist")
            }
            
            self.playlist = PlaylistApi.fromJSON(playlist: data)!
            self.isRefreshing = false
        }
        //TODO: do better error checking
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(playlist: .constant(
            Playlist(name: "playlist name", username: "username")
        ))
    }
}
