//
//  ContentView.swift
//  Music Tools
//
//  Created by Andy Pack on 16/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                Text("Playlists")
                    .font(.title)
                    
            }
            .tabItem {
                VStack {
                    Image("first")
                    Text("Playlists")
                }
            }
            .tag(0)
            Text("Tags")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Tags")
                    }
                }
                .tag(1)
            Text("Settings")
            .font(.title)
            .tabItem {
                VStack {
                    Image("first")
                    Text("Settings")
                }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
