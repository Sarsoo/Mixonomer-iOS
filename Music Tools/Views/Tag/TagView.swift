//
//  TagView.swift
//  Music Tools
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct TagView: View {
    
    init(tag: Tag) {
        self.tag = tag
        
        // hide empty items below list
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var tag: Tag
    
    var body: some View {
        List {
            Section(header: Text("Stats")){
                HStack {
                    Text("Count")
                    Spacer()
                    Text("\(self.tag.count)")
                        .font(.title)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("Proportion")
                    Spacer()
                    Text(String(format: "%.2f%%", self.tag.proportion))
                        .font(.title)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("User Total")
                    Spacer()
                    Text("\(self.tag.total_user_scrobbles)")
                        .font(.title)
                        .foregroundColor(Color.gray)
                }
            }
            Section(header: Text("Music")){
                NavigationLink(destination: TagObjList(objs: self.tag.artists,
                                                       objType: "Artists")) {
                    HStack {
                        Text("Artists")
                        Spacer()
                        Text("\(self.tag.artists.count)")
                            .foregroundColor(Color.gray)
                    }
                }
                
                NavigationLink(destination: TagObjList(objs: self.tag.albums,
                                                       objType: "Albums")) {
                    HStack {
                        Text("Albums")
                        Spacer()
                        Text("\(self.tag.albums.count)")
                            .foregroundColor(Color.gray)
                    }
                }
                
                NavigationLink(destination: TagObjList(objs: self.tag.tracks,
                                                       objType: "Tracks")) {
                    HStack {
                        Text("Tracks")
                        Spacer()
                        Text("\(self.tag.tracks.count)")
                            .foregroundColor(Color.gray)
                    }
                }
            }
            Section(header: Text("Actions")){
                Button(action: { self.runTag() }) {
                    Text("Update")
                }
            }
        }
        .navigationBarTitle(Text(tag.name))
        .onAppear {
            
        }
    }
    
    func runTag() {
        let api = TagApi.runTag(tag_id: tag.tag_id)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
        }
        //TODO: do better error checking
    }
    
    func updateTag(updates: JSON) {
        let api = TagApi.updateTag(tag_id: tag.tag_id, updates: updates)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            
        }
        //TODO: do better error checking
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag:
            Tag(tag_id: "tag_id",
            name: "tag name",
            username: "andy",
            
            tracks: [],
            albums: [],
            artists: [],
            
            count: 20,
            proportion: 0.5,
            total_user_scrobbles: 2000,
            
            last_updated: "10th Feb")
        )
    }
}
