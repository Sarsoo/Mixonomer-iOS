//
//  AddTagSheet.swift
//  Music Tools
//
//  Created by Andy Pack on 02/03/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct AddTagSheet: View {
    
    @State private var name = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    @Binding var state: Bool
    @Binding var tags: Array<Tag>
    @Binding var username: String
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("New Tag")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing], 20.0)

            }
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.bottom, .leading, .trailing], 20.0)
            
            
            
            Button(action: create){
                Text("Add")
                    .font(.title)
            }
            .disabled(isLoading)
            .padding()
            
            Text(errorMessage)
                .foregroundColor(Color.red)
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func create(){
        debugPrint(name)
        let tag_id = self.$name.wrappedValue.replacingOccurrences(of: " ", with: "_")
        
        if tag_id.count == 0 {
            errorMessage = "Enter Tag Name"
            return
        }
        
        var tagPresent = false
        for tag in tags {
            if tag.tag_id == tag_id {
                tagPresent = true
                break
            }
        }
        if tagPresent == true {
            errorMessage = "Tag already created"
            return
        }
        
        let tag = Tag(tag_id: tag_id, name: name, username: self.username, tracks: [], albums: [], artists: [], count: 0, proportion: 0.0, total_user_scrobbles: 0, last_updated: "Never")
        
        isLoading = true
        let api = TagApi.newTag(tag_id: tag_id)
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
            self.tags.append(tag)
            self.tags = self.tags.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            
            self.isLoading = false
            self.state = false
        }
    }
}

struct AddTagSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddTagSheet(state: .constant(true), tags: .constant([]), username: .constant("username"))
    }
}
