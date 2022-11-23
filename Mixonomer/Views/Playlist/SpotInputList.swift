//
//  PlaylistInputList.swift
//  Mixonomer
//
//  Created by Andy Pack on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import ToastUI
import OSLog

struct Name: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct SpotInputList: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @Binding var playlist: Playlist
    @Binding var names: [String]
    
    @State var addName: String = ""
    
    @State private var addAlertShowing = false
    
    @State private var showingToast = false
    @State private var toastText = ""
    @State private var toastSuccess = true
    
    init(names: Binding<[String]>, playlist: Binding<Playlist>){
        self._names = names
        self._playlist = playlist
    }
    
    var body: some View {
        List{
            Section(header: Image(systemName: "music.note")){ // Weird? added empty header as list renders with space for header then jumps up, not nice
                if self.names.count > 0 {
                    ForEach(self.names, id: \.self){ name in
                        Text(name)
                    }
                }else {
                    HStack {
                        Text("No Playlists")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
        }
//        .id(UUID())
        .navigationBarTitle("Spotify Playlists")
        .navigationBarItems(trailing:
            Button(
                action: {
                    addAlertShowing = true
                },
                label: { Image(systemName: "plus.circle") }
            )
            .alert("Add", isPresented: $addAlertShowing, actions: {
                TextField("Playlist Name", text: $addName)
                Button("Add") {
                    
                    let api = PlaylistApi.addPart(name: playlist.name, subject: addName)
                    RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                        
                        if self.liveUser.check_network_response(response: response) {
                            playlist.parts.append(addName)
                            
                            toastText = "Playlist Added"
                            toastSuccess = true
                            showingToast = true
                        }
                        else {
                            Logger.net.error("Failed to add playlist: \(response.response?.statusCode ?? 0)")
                            toastText = "Failed to add playlist"
                            toastSuccess = false
                            showingToast = true
                        }
                    }
                    
                }
                Button("Cancel", role: .cancel) {
                    addAlertShowing = false
                }
            }, message: {
                Text("Enter a playlist name")
                
            })
        )
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
}

struct PlaylistInputList_Previews: PreviewProvider {
    static var previews: some View {
        SpotInputList(names: .constant([
            "name"
        ]), playlist: .constant(Playlist(name: "Name")))
    }
}
