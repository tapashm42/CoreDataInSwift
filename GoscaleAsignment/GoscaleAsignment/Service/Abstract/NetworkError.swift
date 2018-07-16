//
//  NetworkError.swift
//  GoscaleAsignment
//
//  Created by TapashM on 14/07/18.
//  Copyright © 2018 ITC Infotech. All rights reserved.
//

import Foundation
/**
 Net
 */

public enum NetworkError: Error {
    
    case notAValidJSON
    case serverError
    case timeout
    case networkProblem(Error)
    case requestNotReachingToServer
    case unknown(HTTPURLResponse?)
    case userCancelled
    
    public init(statusCode: Int?) {
        if let mStatusCode = statusCode {
            switch mStatusCode {
            case NetworkError.serverError.statusCode: self      = .serverError
            case NetworkError.timeout.statusCode: self          = .timeout
            case NetworkError.notAValidJSON.statusCode: self = .notAValidJSON
            case NetworkError.requestNotReachingToServer.statusCode: self = .requestNotReachingToServer
            default: self = .requestNotReachingToServer
            }
        } else {
            self = .requestNotReachingToServer
        }
    }
    
    public init(error: Error) {
        self = .networkProblem(error)
    }
    
    public init(response: URLResponse?) {
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil)
            return
        }
        switch response.statusCode {
       
        case NetworkError.serverError.statusCode: self      = .serverError
        case NetworkError.timeout.statusCode: self          = .timeout
        case NetworkError.notAValidJSON.statusCode: self = .notAValidJSON
        case NetworkError.requestNotReachingToServer.statusCode: self = .requestNotReachingToServer
        default: self = .unknown(response)
        }
    }
    
    public var statusCode: Int {
        switch self {
       
        case .serverError:       return 500
        case .timeout:           return -1001
        case .networkProblem(_): return 10001
        case .unknown(_):        return 10002
        case .userCancelled:     return 99999
        case .notAValidJSON:       return 5002
        case .requestNotReachingToServer: return 10001
        }
    }
}

// MARK: - Equatable
extension NetworkError: Equatable {
    public static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.statusCode == rhs.statusCode
    }
}
