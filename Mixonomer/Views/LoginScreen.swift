//
//  LoginScreen.swift
//  Mixonomer
//
//  Created by Andy Pack on 17/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import ToastUI
import KeychainAccess
import SwiftyJSON

struct LoginScreen: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var showingToast = false
    @State private var toastText = ""
    
    var body: some View {
        VStack {
            Image("MusicToolsLogo")
                .resizable()
                .frame(width: 200.0, height: 200.0, alignment: .trailing)
                .cornerRadius(18)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)
            Text("Sarsoo's Mixonomer")
                .font(.largeTitle)
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            HStack {
                Button(action: {
                    
                    let keychain = Keychain(service: "xyz.sarsoo.music.login")
                    
                    keychain["username"] = username
                    keychain["password"] = password
                    
                    print(username)
                    print(password)
                    
                    let api = AuthApi.token(username: username, password: password)
                    RequestBuilder.buildRequest(apiRequest: api)
                        .validate()
                        .responseJSON { response in
                            
                            switch response.result {
                            case .success:
                                
                                guard let data = response.data else {
                                    fatalError("error getting token")
                                }

                                guard let json = try? JSON(data: data) else {
                                    fatalError("error parsing reponse")
                                }
                                    
                                let token = json["token"].stringValue
                                
                                keychain["jwt"] = token
                                self.liveUser.loggedIn = true
                                
                            case .failure:
                                
                                keychain["username"] = nil
                                keychain["password"] = nil
                                keychain["jwt"] = nil
                                
                                toastText = "Login Failed"
                                showingToast = true
                            }
                        }
                }) {
                    Text("Log In")
                }
                .padding(.trailing, 20.0)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Register")
                }
            }
            .toast(isPresented: $showingToast, dismissAfter: 3.0){
                ToastView(toastText)
                    .toastViewStyle(.failure)
            }
            .toastDimmedBackground(false)
        }
        .padding()
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
