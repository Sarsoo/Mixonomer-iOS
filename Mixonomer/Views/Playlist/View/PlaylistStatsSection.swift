//
//  PlaylistStatsSection.swift
//  Mixonomer
//
//  Created by Andy Pack on 07/01/2023.
//  Copyright © 2023 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftUICharts
import OSLog

struct PlaylistStatsSection: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @Binding var playlist: Playlist
    
    @Binding var showingToast: Bool
    @Binding var toastText: String
    @Binding var toastSuccess: Bool
    
    var trackChartStyle: ChartStyle {
        get {
            let _style = ChartStyle(backgroundColor: .white, accentColor: Color(red: 0.4765, green: 0.5976, blue: 0.7578), gradientColor: GradientColors.bluPurpl, textColor: .black, legendTextColor: .gray, dropShadowColor: .gray)
            return _style
        }
    }
    
    var albumChartStyle: ChartStyle {
        get {
            let _style = ChartStyle(backgroundColor: .white, accentColor: Color(red: 0.6367, green: 0.2968, blue: 0.4648), gradientColor: GradientColors.bluPurpl, textColor: .black, legendTextColor: .gray, dropShadowColor: .gray)
            return _style
        }
    }
    
    var artistChartStyle: ChartStyle {
        get {
            let _style = ChartStyle(backgroundColor: .white, accentColor: Color(red: 0.3476, green: 0.5195, blue: 0.3359), gradientColor: GradientColors.bluPurpl, textColor: .black, legendTextColor: .gray, dropShadowColor: .gray)
            return _style
        }
    }
    
    var chartSize = CGSize(width:210, height:250);
    
    var body: some View {
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
}

struct PlaylistStatsSection_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistStatsSection(playlist: .constant(Playlist(name: "test")), showingToast: .constant(false), toastText: .constant(""), toastSuccess: .constant(false))
    }
}
