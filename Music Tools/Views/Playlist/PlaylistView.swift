//
//  PlaylistView.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
//import SwiftUIRefresh
import SwiftyJSON

final class ChangeableBool: ObservableObject {
    
    var onClick: () -> ()
    
    init(onClick: @escaping () -> ()) {
        self.onClick = onClick
    }
    
    @Published var state: Bool = false {
        didSet {
            self.onClick()
        }
    }
}

struct PlaylistView: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    init(playlist: Playlist) {
        self.playlist = playlist
        
        // hide empty items below list
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var playlist: Playlist
    @State private var recommendations: Bool = true
    @State private var library_Tracks: Bool = false
    @State private var shuffle: Bool = false
    
    @State private var rec_num: Int = 0
    
    @State private var isRefreshing = false
    
    var body: some View {
        List {
            Section(header: Text("Options")){
                Toggle(isOn: $recommendations) {
                    Text("Spotify Recommendations")
                }
                
//                if recommendations {
                    Stepper(onIncrement: {
                        self.$rec_num.wrappedValue += 1
                        self.updatePlaylist(updates: JSON(["recommendation_sample": self.$rec_num.wrappedValue]))
                    },
                            onDecrement: {
                        self.$rec_num.wrappedValue -= 1
                        self.updatePlaylist(updates: JSON(["recommendation_sample": self.$rec_num.wrappedValue]))
                    }){
                        Text("#:")
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.trailing)
                        Text("\(rec_num)")
                            .multilineTextAlignment(.trailing)
                        
                    }
//                }
                
                Toggle(isOn: $library_Tracks) {
                    Text("Library Tracks")
                }
                
                Toggle(isOn: $shuffle) {
                    Text("Shuffle")
                }
            }
            Section(header: Text("Inputs")){
                NavigationLink(destination: PlaylistInputList(names: self.playlist.playlist_references, nameType: "Managed Playlists")) {
                    HStack {
                        Text("Managed Playlists")
                        Spacer()
                        Text("\(self.playlist.playlist_references.count)")
                            .foregroundColor(Color.gray)
                    }
                }
                
                NavigationLink(destination: PlaylistInputList(names: self.playlist.parts, nameType: "Spotify Playlists")) {
                    HStack {
                        Text("Spotify Playlists")
                        Spacer()
                        Text("\(self.playlist.parts.count)")
                            .foregroundColor(Color.gray)
                    }
                }
            }
            Section(header: Text("Actions")){
                Button(action: { self.runPlaylist() }) {
                    Text("Update")
                }
                
                Button(action: { self.openPlaylist() }) {
                    Text("Open")
                }
            }
        }
//        .pullToRefresh(isShowing: $isRefreshing) {
//            self.refreshPlaylist()
//        }
        .navigationBarTitle(Text(playlist.name))
        .onAppear {
            self.$recommendations.wrappedValue = self.playlist.include_recommendations
            self.$library_Tracks.wrappedValue = self.playlist.include_library_tracks
            self.$shuffle.wrappedValue = self.playlist.shuffle

            self.$rec_num.wrappedValue = self.playlist.recommendation_sample
        }
    }
    
    func runPlaylist() {
        let api = PlaylistApi.runPlaylist(name: playlist.name)
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
    
    func refreshPlaylist(updates: JSON) {
        let api = PlaylistApi.getPlaylist(name: self.playlist.name)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            guard let data = response.data else {
                fatalError("error getting playlist")
            }
            
            guard let json = try? JSON(data: data) else {
                fatalError("error parsing reponse")
            }
            
//            let playlist = Playlist.fromDict(json["playlist"])
//
//            self.playlist = playlist
//            self.isRefreshing = false
        }
        //TODO: do better error checking
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(playlist:
            Playlist(name: "playlist name",
                     uri: "uri",
                     username: "username",
                     
                     include_recommendations: true,
                     recommendation_sample: 5,
                     include_library_tracks: true,
                     
                     parts: ["name"],
                     playlist_references: ["ref name"],
                     
                     shuffle: true)
        )
    }
}
