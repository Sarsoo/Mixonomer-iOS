//
//  NetWorkPersister.swift
//  Music Tools
//
//  Created by Andy Pack on 07/03/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation

@propertyWrapper
struct NetworkPersister<Value: Codable>: Codable {
    
    enum ObjectType: String, Codable {
        case playlist
        case tag
        case user
    }
    
    var objType: ObjectType
    var key: String
//
//    init(_ objType: ObjectType, key: String) {
//        self.objType = objType
//        self.key = key
//    }
    
    var wrappedValue: Value {
        didSet {
            print("set")
        }
    }
    
}
