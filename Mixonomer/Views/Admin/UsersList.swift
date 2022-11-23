//
//  UsersList.swift
//  Mixonomer
//
//  Created by Andy Pack on 13/08/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import OSLog

struct UsersList: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    @State private var users: [User] = []
    
    var body: some View {
        List{
            Section { // Weird? added empty header as list renders with space for header then jumps up, not nice
                if self.users.count > 0 {
                    ForEach(self.users.indices, id: \.self){ userIdx in
                        
                        NavigationLink(destination: UserView(user: self.$users[userIdx])) {
                            Text(self.users[userIdx].username)
                        }
                    }
                }else {
                    HStack {
                        Text("No Users")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
        }
//        .id(UUID())
        .navigationBarTitle("Users")
        .onAppear {
            self.get_users()
        }
    }
    
    func get_users() {
        let api = AdminApi.getUsers
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
            if self.liveUser.check_network_response(response: response) {
                
                guard let data = response.data else {
                    Logger.net.error("failed to get users")
                    return
                }

                guard let json = try? JSON(data: data) else {
                    Logger.parse.error("failed to get users")
                    return
                }
                
                // update state
                self.users = UserApi.fromJSON(user: json["accounts"].arrayValue)
                                .sorted(by: { (user1, user2) in
                                    return user1.username < user2.username
                                })
                
            } else {
                Logger.net.error("failed to get users from view")
            }
        }
    }
}

struct UsersList_Previews: PreviewProvider {
    static var previews: some View {
        UsersList()
            .environmentObject(LiveUser(playlists: [], tags: [], username: "user", loggedIn: false))
    }
}
