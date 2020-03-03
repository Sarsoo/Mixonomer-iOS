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
    
    init(){
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        VStack{
        List{
            Button(action: {
                if let url = URL(string: "https://music.sarsoo.xyz") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Open Web")
            }
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
        Image("APFooter")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100.0)
        }
    }
}

struct SettingsList_Previews: PreviewProvider {
    static var previews: some View {
        SettingsList()
    }
}
