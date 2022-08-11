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
        NavigationView {
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
                        self.liveUser.logout()
                    }) {
                        Text("Log out")
                    }
                }
                Section {
                    Button(action: {
                        deleteAlertShowing = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                    .alert("Delete Account", isPresented: $deleteAlertShowing, actions: {
                        Text("This will irreversibly delete all of your data, are you sure?")
                        Button("Delete", role: .destructive) {
                            
                            let api = UserApi.deleteUser
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                                if self.liveUser.checkNetworkResponse(response: response) {
                                    
                                    self.liveUser.logout()
                                }
                                else {
                                    
                                }
                            }
                            
                        }
                        Button("Cancel", role: .cancel) {
                            deleteAlertShowing = false
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
