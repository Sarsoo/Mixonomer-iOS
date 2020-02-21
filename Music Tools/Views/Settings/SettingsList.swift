//
//  SettingsList.swift
//  Music Tools
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import KeychainAccess

struct SettingsList: View {
    var body: some View {
        List{
            Button(action: {
                let keychain = Keychain(service: "xyz.sarsoo.music.login")
                do {
                    try keychain.remove("username")
                    try keychain.remove("password")
                } catch let error {
                    debugPrint("Could not clear keychain, \(error)")
                }
            }) {
                Text("Log out")
            }
        }
    }
}

struct SettingsList_Previews: PreviewProvider {
    static var previews: some View {
        SettingsList()
    }
}
