//
//  ReachabilityManager.swift
//  GoscaleAsignment
//
//  Created by TapashM on 14/07/18.
//  Copyright © 2018 ITC Infotech. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

typealias NetworkCompletionHandler = (NetworkRequestModel, Data?, URLResponse?, Error?, Int?, Bool) -> Void

final class ReachabilityManager {
    
    static let shared = ReachabilityManager()
    
    private  init() {
        //This prevents others from using the default '()' initializer for this class
    }
    
    private lazy var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15.0
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    fileprivate var allRunningNetworkCalls = [URLSessionDataTask : NetworkRequestModel]()
    
    func httpCall(model: NetworkRequestModel, completionHandler: @escaping NetworkCompletionHandler) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        guard let mURl = URL(string: model.url) else {
            completionHandler(model, nil, nil, nil, nil, false)
            return
        }
        
        var request = URLRequest(url: mURl)
        request.allHTTPHeaderFields = model.headers
        
        switch model.httpMethod {
        case .POST:
            request.httpMethod = "POST"
            do {
                if let mModelBody = model.body {
                    request.httpBody = try JSONSerialization.data(withJSONObject: mModelBody, options: [])
                }
            } catch let error {
                print(error.localizedDescription)
            }
            break
            
        case .GET:
            request.httpMethod = "GET"
            break
        }
        
        let networkCall = defaultSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard error == nil else {
                completionHandler(model, nil, response, error, (response as? HTTPURLResponse)?.statusCode, false)
                print(" ----- >>>>> Error: - \(String(describing: error?.localizedDescription)) <<<<< ----- ")
                return
            }
            
            guard let mResponse = response else {
                completionHandler(model, nil, nil, nil, nil, false)
                print(" ----- >>>>> Error:Response nil <<<<< ----- ")
                return
            }
            
            guard let mData = data else {
                completionHandler(model, nil, response, error, nil, false)
                print(" ----- >>>>> Error: did not receive data <<<<< ----- ")
                return
            }
            
            if let mStatuscode = response as? HTTPURLResponse {
                switch mStatuscode.statusCode {
                case 200:
                    completionHandler(model, mData, mResponse, nil, mStatuscode.statusCode, true)
                    break
                    
                default:
                    completionHandler(model, mData, mResponse, nil, mStatuscode.statusCode, false)
                    break
                }
            } else {
                completionHandler(model, mData, mResponse, nil, nil, false)
            }
        }
        networkCall.resume()
        
        DispatchQueue.main.async {
            self.allRunningNetworkCalls[networkCall] = model
        }
    }
    
    func cancelAllHttpCalls() {
        for currentTask in allRunningNetworkCalls {
            currentTask.key.cancel()
        }
    }
    
    func cancelHttpCall(identifier: String ){
        for currentTask in allRunningNetworkCalls {
            if currentTask.value.taskIdentifier == identifier {
                currentTask.key.cancel()
                self.allRunningNetworkCalls.removeValue(forKey: currentTask.key)
            }
        }
    }
}

extension ReachabilityManager {
    func isNetworkReachable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
