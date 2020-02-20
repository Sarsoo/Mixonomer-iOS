//
//  TagRow.swift
//  Music Tools
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct TagRow: View {
    
    @EnvironmentObject var liveUser: LiveUser
    
    var tag: Tag
    
    var body: some View {
        NavigationLink(destination: TagView(tag: tag)){
            HStack {
                Text(tag.name)
                    .contextMenu {
                        
                        // run force touch
                        Button(action: {
                            let api = TagApi.runTag(tag_id: self.tag.tag_id)
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                            }
                        }) {
                            Text("Refresh")
                            Image(systemName: "arrow.clockwise.circle")
                        }
                    }
            }
        }
    }
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag:
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
