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

enum ScreenMode {
    case None
    case Login
    case Register
}

struct LoginScreen: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var password2: String = ""
    
    @State private var showingToast = false
    @State private var toastText = ""

    @State public var screenMode = ScreenMode.None
    
    var body: some View {
        VStack {
            Image("MusicToolsLogo")
                .resizable()
                .frame(width: 200.0, height: 200.0, alignment: .trailing)
                .cornerRadius(18)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)
            Text("Mixonomer")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            if screenMode != .None {
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            
            if screenMode == .Register {
                SecureField("Password Again", text: $password2)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 20)
            }
            
            if screenMode == .None {
                HStack {
                    Button(action: {
                        
                        screenMode = .Login
                        
                    }) {
                        Text("Log In")
                    }
                    .buttonStyle(.bordered)
                    .padding(.trailing, 20.0)
                    Button(action: {
                        
                        screenMode = .Register
                        
                    }) {
                        Text("Register")
                    }.buttonStyle(.bordered)
                }
            }
            
            if screenMode == .Login {
                Button(action: {
                    
                    let keychain = Keychain(service: "xyz.sarsoo.music.login")
                    
                    keychain["username"] = username
                    
                    let api = AuthApi.token(username: username, password: password, expiry: 604800)
                    RequestBuilder.buildRequest(apiRequest: api)
                        .validate()
                        .responseJSON { response in
                            
                            switch response.response?.statusCode {
                            case 200, 201:
                                
                                guard let data = response.data else {
                                    fatalError("error getting token")
                                }

                                guard let json = try? JSON(data: data) else {
                                    fatalError("error parsing reponse")
                                }
                                    
                                let token = json["token"].stringValue
                                
                                keychain["jwt"] = token
                                self.liveUser.loggedIn = true
                                
                            case _:
                                
                                keychain["username"] = nil
                                keychain["jwt"] = nil
                                
                                toastText = "Login Failed"
                                showingToast = true
                            }
                        }
                }) {
                    Text("Log In")
                }
                .buttonStyle(.bordered)
                .padding(.top, 20)
            }
            
            if screenMode == .Register {
                Button(action: {
                    
                    let keychain = Keychain(service: "xyz.sarsoo.music.login")
                    
                    keychain["username"] = username
                    
                    let api = AuthApi.register(username: username, password: password, password2: password2)
                    RequestBuilder.buildRequest(apiRequest: api)
                        .validate()
                        .responseJSON { response in
                            
                            switch response.response?.statusCode {
                            case 200, 201:
                                
                                let token_api = AuthApi.token(username: username, password: password, expiry: 604800)
                                RequestBuilder.buildRequest(apiRequest: token_api)
                                    .validate()
                                    .responseJSON { response in
                                        
                                        switch response.response?.statusCode {
                                        case 200, 201:
                                            
                                            guard let data = response.data else {
                                                fatalError("error getting token")
                                            }

                                            guard let json = try? JSON(data: data) else {
                                                fatalError("error parsing reponse")
                                            }
                                                
                                            let token = json["token"].stringValue
                                            
                                            keychain["jwt"] = token
                                            self.liveUser.loggedIn = true
                                            
                                        case _:
                                            
                                            keychain["username"] = nil
                                            keychain["jwt"] = nil
                                            
                                            toastText = "Token Generation Failed"
                                            showingToast = true
                                        }
                                    }
                                
                                // TODO: add handling for 400, password dont match
                                // TODO: add handling for 409, conflict
                                
                            case _:
                                
                                keychain["username"] = nil
                                keychain["jwt"] = nil
                                
                                toastText = "Register Failed"
                                showingToast = true
                            }
                        }
                }) {
                    Text("Register")
                }
                .buttonStyle(.bordered)
            }
        }
        .toast(isPresented: $showingToast, dismissAfter: 3.0){
            ToastView(toastText)
                .toastViewStyle(.failure)
        }
        .toastDimmedBackground(false)
        .padding()
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LoginScreen(screenMode: .None)
                .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
            LoginScreen(screenMode: .Login)
                .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
            LoginScreen(screenMode: .Register)
                .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
        }
    }
}
