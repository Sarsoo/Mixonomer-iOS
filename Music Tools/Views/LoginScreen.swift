//
//  LoginScreen.swift
//  Music Tools
//
//  Created by Andy Pack on 17/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Image("MusicToolsLogo")
                .resizable()
                .frame(width: 200.0, height: 200.0, alignment: .trailing)
                .cornerRadius(18)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)
            Text("Sarsoo Music Tools")
                .font(.largeTitle)
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            HStack {
                Button(action: {
                    self.liveUser.loggedIn = true
                }) {
                    Text("Log In")
                }
                .padding(.trailing, 20.0)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Register")
                }
            }
        }
        .padding()
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
