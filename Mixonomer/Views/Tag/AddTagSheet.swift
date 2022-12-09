//
//  AddTagSheet.swift
//  Mixonomer
//
//  Created by Andy Pack on 02/03/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct AddTagSheet: View {
    
    @EnvironmentObject var liveUser: LiveUser
    @State private var name = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    @Environment(\.presentationMode) var presentationMode
    
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
            
            if self.liveUser.check_network_response(response: response) {
                
                self.tags.append(tag)
                self.tags = self.tags.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                
                self.isLoading = false
                self.presentationMode.wrappedValue.dismiss()
                
            } else {
                
            }
        }
    }
}

struct AddTagSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddTagSheet(tags: .constant([]), username: .constant("username"))
            .environmentObject(LiveUser.get_preview_user())
    }
}
