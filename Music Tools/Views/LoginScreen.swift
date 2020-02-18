//
//  LoginScreen.swift
//  Music Tools
//
//  Created by Andy Pack on 17/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 200.0, height: 200.0, alignment: .trailing)
                .cornerRadius(18)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)
            Text("Sarsoo Music Tools")
                .font(.largeTitle)
            TextField("Username", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            SecureField("Password", text: /*@START_MENU_TOKEN@*/ /*@PLACEHOLDER=Value@*/.constant("Apple")/*@END_MENU_TOKEN@*/)
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
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
