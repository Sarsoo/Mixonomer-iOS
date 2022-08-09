//
//  TagRow.swift
//  Mixonomer
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct TagRow: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @Binding var tag: Tag
    @State private var showingNetworkError = false
    
    var body: some View {
        NavigationLink(destination: TagView(tag: $tag)){
            HStack {
                Text(tag.name)
                if tag.count > 0 {
                    Spacer()
                    Text("\(tag.count)")
                        .foregroundColor(.gray)
                }
            }.contextMenu {
                Button(action: {
                    let api = TagApi.runTag(tag_id: self.tag.tag_id)
                    RequestBuilder.buildRequest(apiRequest: api)
                        .validate()
                        .responseJSON{ response in
                            
                            self.liveUser.checkNetworkResponse(response: response)
                            
                            switch response.response?.statusCode {
                            case 200, 201:
                                break
                            case _:
                                self.showingNetworkError = true
                            }
                        }
                }) {
                    Text("Refresh")
                    Image(systemName: "arrow.clockwise.circle")
                }
            }.alert(isPresented: $showingNetworkError) {
                Alert(title: Text("Network Error"),
                      message: Text("Could not refresh tag"))
            }
        }
    }
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag: .constant(
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
        ))
    }
}
