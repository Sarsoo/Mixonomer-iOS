//
//  TagView.swift
//  Mixonomer
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SwiftUICharts

struct TagView: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @Binding var tag: Tag
    
    @State private var isRefreshing = false
    
    var chartStyle: ChartStyle {
        get {
            let _style = Styles.barChartStyleNeonBlueLight
            _style.darkModeStyle = Styles.barChartStyleNeonBlueDark
            return _style
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Stats")){
                HStack {
                    Text("Count")
                    Spacer()
                    Text("\(self.tag.count)")
                        .font(.title)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("Proportion")
                    Spacer()
                    Text(String(format: "%.2f%%", self.tag.proportion))
                        .font(.title)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("Total")
                    Spacer()
                    Text("\(self.tag.total_user_scrobbles)")
                        .font(.title)
                        .foregroundColor(Color.gray)
                }
            }
            Section(header: Text("Music")){
                NavigationLink(destination: TagObjList(objs: self.tag.artists,
                                                       objType: "Artists")) {
                    HStack {
                        Text("Artists")
                        Spacer()
                        Text("\(self.tag.artists.count)")
                            .foregroundColor(Color.gray)
                    }
                }
                
                NavigationLink(destination: TagObjList(objs: self.tag.albums,
                                                       objType: "Albums")) {
                    HStack {
                        Text("Albums")
                        Spacer()
                        Text("\(self.tag.albums.count)")
                            .foregroundColor(Color.gray)
                    }
                }
                
                NavigationLink(destination: TagObjList(objs: self.tag.tracks,
                                                       objType: "Tracks")) {
                    HStack {
                        Text("Tracks")
                        Spacer()
                        Text("\(self.tag.tracks.count)")
                            .foregroundColor(Color.gray)
                    }
                }
            }
            HStack {
                Spacer()
                BarChartView(
                    data: ChartData(values:
                        self.tag.all
                            .filter {
                                $0["count"].intValue > 0
                        }
                        .sorted {
                            $0["name"].stringValue.lowercased() < $1["name"].stringValue.lowercased()
                        }.map {
                    ($0["name"].stringValue, $0["count"].intValue)
                }),
                    title: self.tag.name,
                    legend: "Scrobbles", style: chartStyle,
                    form: CGSize(width: 250, height: 300),
                    cornerImage: Image(systemName: "music.note")
                )
                .padding()
//                .frame(width: 100, height: 400)
                Spacer()
            }
            Section(header: Text("Actions"),
                    footer: Text("Last Updated \(self.tag.last_updated ?? "never")")){
                Button(action: { self.runTag() }) {
                    Text("Update")
                }
            }
        }.listStyle(GroupedListStyle())
        .refreshable {
            self.refreshTag()
        }
        .navigationBarTitle(Text(tag.name))
    }
    
    func runTag() {
        let api = TagApi.runTag(tag_id: tag.tag_id)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.check_network_response(response: response) {
                
            } else {
                
            }
        }
        //TODO: do better error checking
    }
    
    func updateTag(updates: JSON) {
        let api = TagApi.updateTag(tag_id: tag.tag_id, updates: updates)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.check_network_response(response: response) {
                
            } else {
                
            }
        }
        //TODO: do better error checking
    }
    
    func refreshTag() {
        let api = TagApi.getTag(tag_id: self.tag.tag_id)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.check_network_response(response: response) {
                
                guard let data = response.data else {
                    fatalError("error getting tag")
                }
                
                guard let json = try? JSON(data: data) else {
                    fatalError("error parsing reponse")
                }
                let _tag = TagApi.fromJSON(tag: json["tag"])
                if let tag = _tag {
                    self.tag = tag
                }
                
            } else {
                
            }
            
            self.isRefreshing = false
        }
        //TODO: do better error checking
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag: .constant(
            Tag(tag_id: "tag_id",
            name: "tag name",
            username: "andy",
            
            tracks: [],
            albums: [],
            artists: [],
            
            count: 20,
            proportion: 0.5,
            total_user_scrobbles: 2000,
            
            last_updated: "10th Feb")
        ))
        .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
    }
}
