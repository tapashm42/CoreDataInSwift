//
//  NetworkRequestModel.swift
//  GoscaleAsignment
//
//  Created by TapashM on 14/07/18.
//  Copyright © 2018 ITC Infotech. All rights reserved.
//


import Foundation

enum HTTPVerb: String {
    case GET  = "GET"
    case POST = "POST"
}

struct NetworkRequestModel {
    var url: String
    var taskIdentifier: String
    var body: [String: Any]?
    var httpMethod: HTTPVerb
    var headers: [String: String]?
    
    init(url: String, taskIdentifier: String, httpMethod:HTTPVerb, body:[String: Any]?, headers:[String: String]?) {
        self.url = url
        self.taskIdentifier = taskIdentifier
        self.body = body
        self.httpMethod = httpMethod
        self.headers = headers
    }
}
