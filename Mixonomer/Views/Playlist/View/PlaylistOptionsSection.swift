//
//  PlaylistOptionsSection.swift
//  Mixonomer
//
//  Created by Andy Pack on 07/01/2023.
//  Copyright © 2023 Sarsoo. All rights reserved.
//

import SwiftUI

struct PlaylistOptionsSection: View {
    
    @Binding var playlist: Playlist
    @Binding var showingSheet: Bool
    
    var body: some View {
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
    }
}

struct PlaylistOptionsSection_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistOptionsSection(playlist: .constant(Playlist(name: "Test")), showingSheet: .constant(false))
    }
}
