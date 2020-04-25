//
//  Router.swift
//  Music Tools
//
//  Created by Andy Pack on 25/04/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

// Root level view loaded by delegate to show either main app or login screen
struct Router: View {
    
    @EnvironmentObject var liveUser: LiveUser

    @ViewBuilder
    var body: some View {
        if liveUser.loggedIn {
            AppSkeleton()
        }
        else {
            LoginScreen()
        }
    }
}

struct Router_Previews: PreviewProvider {
    static var previews: some View {
        Router()
    }
}
