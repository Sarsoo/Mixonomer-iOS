//
//  NetWorkPersister.swift
//  Mixonomer
//
//  Created by Andy Pack on 07/03/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation

enum ObjectType: String, Codable {
    case playlist
    case tag
    case user
}

//@propertyWrapper public struct NetworkPersister<Value: Codable>: Codable {
//
////    var objType: ObjectType
////    var key: String
////    var value: Value
//
////    var sets = 0
//
////    public init(wrappedValue: Value) {
//////        self.objType = objType
//////        self.key = key
////        self.value = wrappedValue
////    }
//
//    public var wrappedValue: Value {
//        didSet(newValue) {
//            print(newValue)
//        }
//    }
//
//}
