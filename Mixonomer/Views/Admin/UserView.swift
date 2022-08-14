//
//  UserView.swift
//  Mixonomer
//
//  Created by Andy Pack on 14/08/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @Binding var user: User
    
    var body: some View {
        Form {
            
            Section {
                HStack {
                    Text("Type")
                    Spacer()
                    Text(user.type.rawValue)
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("External")) {
                HStack {
                    Text("Spotify")
                    Spacer()
                    Text(user.spotify_linked ? "✅" : "❌")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Last.fm")
                    Spacer()
                    Text(user.lastfm_username ?? "")
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("Timestamps")) {
                HStack {
                    Text("Last Web Login")
                    Spacer()
                    Text(user.last_login)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Last Keygen")
                    Spacer()
                    Text(user.last_keygen)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationBarTitle(Text(user.username))
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: .constant(User(username: "", email: "", last_login: "", last_keygen: "", spotify_linked: true, lastfm_username: nil)))
    }
}
