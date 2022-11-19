//
//  SettingsList.swift
//  Mixonomer
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import KeychainAccess

struct SettingsList: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @State private var deleteAlertShowing = false
    
    var body: some View {
        
        let spotify_link_bind = Binding<Bool>(get: { liveUser.user?.spotify_linked ?? false},
                                               set: { newVal in liveUser.user?.spotify_linked = newVal })
//        let lastfm_bind = Binding<String>(get: { liveUser.user?.lastfm_username ?? ""},
//                                          set: { newVal in liveUser.user?.lastfm_username = newVal })
        
        return NavigationView {
            List{
                Section {
                    Button(action: {
                        if let url = URL(string: "https://mixonomer.sarsoo.xyz") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Launch Web Version")
                    }
                    Button(action: {
                        if let url = URL(string: "https://mixonomer.sarsoo.xyz/privacy") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Privacy Policy")
                    }
                    Button(action: {
                        self.liveUser.logout()
                    }) {
                        Text("Log out")
                    }
                }
                
                Section(header: Text("Integrations")) {
                    Toggle(isOn: spotify_link_bind) {
                        Text("Spotify Link")
                    }
                    .disabled(true)
                    
//                    NavigationLink("Last.fm Username") {
//                        List{
//                            TextField("Username", text: lastfm_bind)
//                        }
//                    }
                }
                
//                Section(header: Text("Last.fm")) {
//                    TextField("Last.fm Username", text: lastfm_bind)
//                }
                
                Section {
                    Button(action: {
                        deleteAlertShowing = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                    .alert("Delete Account", isPresented: $deleteAlertShowing, actions: {
                        Button("Delete", role: .destructive) {

                            let api = UserApi.deleteUser
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in

                                if self.liveUser.check_network_response(response: response) {

                                    self.liveUser.logout()
                                }
                                else {

                                }
                            }

                        }
                    }, message: {
                        Text("This is irreversible, are you sure you want to delete your account?")
                    })
                }
                Section(
                    header:
                        Text("Development"),
                    footer:
                        HStack{
                            Spacer()
                            Image("APFooter")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100.0)
                            Spacer()
                        }
                ) {
                    Button(action: {
                        if let url = URL(string: "https://github.com/sarsoo/Mixonomer") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Server Source")
                    }
                    Button(action: {
                        if let url = URL(string: "https://github.com/sarsoo/Mixonomer-ios") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("iOS Source")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Settings ⚡️"))
        }
    }
}

struct SettingsList_Previews: PreviewProvider {
    static var previews: some View {
        SettingsList()
            .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
    }
}
