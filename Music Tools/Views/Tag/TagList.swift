//
//  TagList.swift
//  Mixonomer
//
//  Created by Andy Pack on 25/04/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI

struct TagList: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @State private var showAdd = false // State for showing add modal view
    
    var body: some View {
        NavigationView {
            List{
                if(liveUser.tags.count > 0) {
                    ForEach(liveUser.tags.indices, id:\.self) { idx in
                        TagRow(tag: self.$liveUser.tags[idx])
                    }
                    .onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            let api = TagApi.deleteTag(tag_id: self.liveUser.tags[index].tag_id)
                            RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                                
                            }
                        }
                        
                        self.liveUser.tags.remove(atOffsets: indexSet)
                    }
                } else {
                    Text("No Tags")
                }
            }
            .refreshable {
                self.liveUser.refreshTags()
            }
            .navigationBarTitle(Text("Tags 🎷"))
            .navigationBarItems(
                leading:
                    EditButton(),
                
                trailing:
                    Button(
                        action: { self.showAdd = true },
                        label: { Text("Add") }
                    ).sheet(isPresented: $showAdd) {
                        AddTagSheet(tags: self.$liveUser.tags, username: self.$liveUser.username)
                    }
            )
        }
    }
}

struct TagList_Previews: PreviewProvider {
    static var previews: some View {
        TagList()
    }
}
