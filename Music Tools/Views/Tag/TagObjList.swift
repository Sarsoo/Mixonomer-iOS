//
//  TagObjList.swift
//  Music Tools
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct MusicObj: Identifiable {
    var id = UUID()
    var name: String
    var artist: String
    var count: Int
}

struct TagObjList: View {
    
    var objs: Array<MusicObj> = []
    var objType: String
    
    init(objs: Array<JSON>, objType: String){
        self.objType = objType
        self.objs = objs.map { (obj) -> MusicObj in
            return MusicObj(name: obj["name"].stringValue,
                            artist: obj["artist"].stringValue,
                            count: obj["count"].intValue)
        }.sorted(by: { $0.count > $1.count })
        
    }
    
    init(musicObjs: [MusicObj], objType: String){
        self.objType = objType
        self.objs = objs.sorted(by: { $0.count > $1.count })
    }
    
    var body: some View {
        return List(objs) { obj in
            HStack {
                VStack(alignment: .leading){
                    Text(obj.name)
//                        .multilineTextAlignment(.leading)
                    if obj.artist.count > 0 {
                        Text(obj.artist)
//                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.gray)
                    }
                }
                Spacer()
                Text("\(obj.count)")
                    .foregroundColor(Color.gray)
            }
        }
        .navigationBarTitle(Text(objType))
        .navigationBarItems(trailing:
            Button(
                action: {  },
                label: { Image(systemName: "plus.circle") }
            )
        )
    }
}

struct TagObjList_Previews: PreviewProvider {
    static var previews: some View {
        TagObjList(musicObjs: [
            MusicObj(name: "To Pimp A Butterfly", artist: "Kendrick Lamar", count: 10)
        ], objType: "Albums")
    }
}
