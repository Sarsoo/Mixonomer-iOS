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
                        let keychain = Keychain(service: "xyz.sarsoo.music.login")
                        do {
                            try keychain.remove("username")
                            try keychain.remove("password")
                            
                            self.liveUser.loggedIn = false
                            
                        } catch let error {
                            debugPrint("Could not clear keychain, \(error)")
                        }
                    }) {
                        Text("Log out")
                    }
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
            .navigationBarTitle(Text("Settings ⚡️").font(.title))
        }
    }
}

struct SettingsList_Previews: PreviewProvider {
    static var previews: some View {
        SettingsList()
    }
}
