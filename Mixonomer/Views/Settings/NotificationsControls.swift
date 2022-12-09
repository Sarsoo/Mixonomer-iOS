//
//  NotificationsControls.swift
//  Mixonomer
//
//  Created by Andy Pack on 27/11/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import SwiftUI

struct NotificationsControls: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: self.$liveUser.user.notify) {
                    Text("Enabled")
                }
            }
            Section {
                Button("Request permission on this device") {
                    self.liveUser.requestAPNSPerms()
                }
            }
            Section {
                Toggle(isOn: self.$liveUser.user.notify_playlist_updates) {
                    Text("Playlist Updates")
                }
                Toggle(isOn: self.$liveUser.user.notify_tag_updates) {
                    Text("Tag Updates")
                }
                
                if liveUser.user.type == .admin {
                    Toggle(isOn: self.$liveUser.user.notify_admins) {
                        Text("Admin Updates")
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Notifications 🔔"))
    }
}

struct NotificationsControls_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsControls()
            .environmentObject(LiveUser.get_preview_user())
    }
}
