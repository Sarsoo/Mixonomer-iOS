//
//  EndPointType.swift
//  Music Tools
//
//  Created by Ellie McCarthy on 17/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation

protocol EndPointType {
    var domain: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String:Any]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
}
