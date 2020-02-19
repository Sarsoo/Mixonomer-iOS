//
//  PlaylistView.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct PlaylistView: View {
    var playlist: Playlist
    @State private var recommendations: Bool = false
    @State private var library_Tracks: Bool = false
    @State private var shuffle: Bool = false
    
    @State private var rec_num: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(playlist.name)
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Text(playlist.username)
                    .foregroundColor(Color.gray)
                    .padding(.leading)
                Image("PlaylistCoverImage")
                        .resizable()
                        .frame(width: 200.0, height: 200.0, alignment: .trailing)
                        .cornerRadius(18)
                        .padding(.all, 20)
                
                Toggle(isOn: $recommendations) {
                    Text("Spotify Recommendations")
                }
                .padding()
                
                if recommendations {
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
                            .padding(.leading, 20)
                        Text("\(rec_num)")
                            .multilineTextAlignment(.trailing)
                        
                    }.padding()
                }
                
                Toggle(isOn: $library_Tracks) {
                    Text("Library Tracks")
                }.padding()
                
                Toggle(isOn: $shuffle) {
                    Text("Shuffle")
                }.padding()
                
                HStack {
                    Button(action: { self.runPlaylist() }) {
                        Text("Update")
                    }.padding().multilineTextAlignment(.center)
                }
                
                Spacer()
                
            }
            .padding(.vertical)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .onAppear {
                self.$recommendations.wrappedValue = self.playlist.include_recommendations
                self.$library_Tracks.wrappedValue = self.playlist.include_library_tracks
                self.$shuffle.wrappedValue = self.playlist.shuffle
                
                self.$rec_num.wrappedValue = self.playlist.recommendation_sample
            }
        }
    }
    
    func runPlaylist() {
        let api = PlaylistApi.runPlaylist(name: playlist.name)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            guard let data = response.data else {
                fatalError("error getting playlists")
            }
            
            guard let json = try? JSON(data: data) else {
                fatalError("error parsing reponse")
            }
        }
        //TODO: do better error checking
    }
    
    func updatePlaylist(updates: JSON) {
        let api = PlaylistApi.updatePlaylist(name: playlist.name, updates: updates)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            guard let data = response.data else {
                fatalError("error getting playlists")
            }
            
            guard let json = try? JSON(data: data) else {
                fatalError("error parsing reponse")
            }
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
