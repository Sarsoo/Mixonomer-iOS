//
//  AddPlaylistSheet.swift
//  Music Tools
//
//  Created by Andy Pack on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct AddPlaylistSheet: View {
    
    @State private var selectedType = 0
    @State private var name = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    @Binding var state: Bool
    @Binding var playlists: Array<Playlist>
    @Binding var username: String
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("New Playlist")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing], 20.0)

            }
            Picker(selection: $selectedType, label: Text("Picker")) {
                Text("Default").tag(0)
                Text("Recents").tag(1)
                Text("Last.fm Chart").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.bottom, .leading, .trailing], 20.0)
            
            
            
            Button(action: create){
                Text("Add")
                    .font(.title)
            }
            .disabled(isLoading)
            .padding()
            
            Text(errorMessage)
                .foregroundColor(Color.red)
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func create(){
        if name.count == 0 {
            errorMessage = "Enter Playlist Name"
            return
        }
        
        var namePresent = false
        for playlist in playlists {
            if playlist.name == name {
                namePresent = true
                break
            }
        }
        if namePresent == true {
            errorMessage = "Playlist already created"
            return
        }
        
        var playlist: Playlist? = nil
        switch PlaylistType(rawValue: selectedType) ?? .defaultPlaylist {
        case .defaultPlaylist:
            playlist = Playlist(name: name, username: username)
            break
        case .recents:
            playlist = RecentsPlaylist(name: name, username: username)
            break
        case .fmchart:
            playlist = LastFMChartPlaylist(name: name, username: username)
            break
        }
        
        isLoading = true
        let api = PlaylistApi.newPlaylist(name: self.name,
                                          type: PlaylistType(rawValue: selectedType) ?? .defaultPlaylist)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            self.playlists.append(playlist!)
            self.playlists = self.playlists.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            
            self.isLoading = false
            self.state = false
        }
    }
}

struct AddPlaylistSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaylistSheet(state: .constant(true), playlists: .constant([]), username: .constant("username"))
    }
}
