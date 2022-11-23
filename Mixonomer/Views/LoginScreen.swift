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
import OSLog

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
                    
                    Logger.sys.debug("making login request")
                    
                    let api = AuthApi.token(username: username, password: password, expiry: 604800)
                    RequestBuilder.buildRequest(apiRequest: api)
                        .validate()
                        .responseJSON { response in
                            
                            let code = response.response?.statusCode ?? -1
                            
                            switch code {
                            case 200, 201:
                                
                                guard let data = response.data else {
                                    Logger.net.error("failed to get API token from request")
                                    return
                                }
                                
                                guard let json = try? JSON(data: data) else {
                                    Logger.parse.error("failed to parse API token")
                                    return
                                }
                                
                                let token = json["token"].stringValue
                                
                                keychain["jwt"] = token
                                self.liveUser.loggedIn = true
                                
                                Logger.net.info("login succeeded (\(code))")
                            case _:
                                
                                keychain["username"] = nil
                                keychain["jwt"] = nil
                                
                                toastText = "Login Failed"
                                showingToast = true
                                
                                if let data = response.data {
                                    Logger.net.info("login failed (\(code)): \(data)")
                                    return
                                }
                                else {
                                    Logger.net.info("login failed (\(code))")
                                }
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
                    
                    Logger.sys.debug("making register request")
                    
                    let api = AuthApi.register(username: username, password: password, password2: password2)
                    RequestBuilder.buildRequest(apiRequest: api)
                        .validate()
                        .responseJSON { response in
                            
                            let registerCode = response.response?.statusCode ?? -1
                            
                            switch registerCode {
                            case 200, 201:
                                
                                Logger.net.debug("register request succeeded, logging in")
                                
                                let token_api = AuthApi.token(username: username, password: password, expiry: 604800)
                                RequestBuilder.buildRequest(apiRequest: token_api)
                                    .validate()
                                    .responseJSON { response in
                                        
                                        let loginCode = response.response?.statusCode ?? -1
                                        
                                        switch loginCode {
                                        case 200, 201:
                                            
                                            guard let data = response.data else {
                                                Logger.net.error("failed to get API token for register from login request")
                                                return
                                            }

                                            guard let json = try? JSON(data: data) else {
                                                Logger.parse.error("failed to parse API token for register from login request")
                                                return
                                            }
                                                
                                            let token = json["token"].stringValue
                                            
                                            keychain["jwt"] = token
                                            self.liveUser.loggedIn = true
                                            
                                        case _:
                                            
                                            keychain["username"] = nil
                                            keychain["jwt"] = nil
                                            
                                            toastText = "Token Generation Failed"
                                            showingToast = true
                                            
                                            Logger.net.error("failed to login post-registration (\(loginCode)")
                                        }
                                    }
                                
                            case 400:
                                Logger.net.info("register failed, passwords didn't match (400)")
                                
                            case 409:
                                Logger.net.info("register failed, username already exists (409)")
                                
                            case _:
                                
                                Logger.net.info("register request failed (\(registerCode)")
                                
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
            
            Button(action: {
                UIApplication.shared.open(URL(string: "https://mixonomer.sarsoo.xyz/privacy")!)
            }) {
                Text("Privacy Policy")
            }
            .padding(.top, 20)
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
