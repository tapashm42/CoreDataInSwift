//
// GANetwork.swift
//  GoscaleAsignment
//
//  Created by TapashM on 14/07/18.
//  Copyright © 2018 ITC Infotech. All rights reserved.
//

import Foundation

final class GANetwork {
    
    static let shared = GANetwork()
    private init() { }
    
    // MARK: - Operation Queue
    private lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.itcinfotech.GANetworkingQueue"
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
}

// MARK: - Cancelling APIs (General)
extension GANetwork {
    func cancelAll() {
        downloadQueue.cancelAllOperations()
    }
    
    func cancelOperation(identifier: String) {
        for operation in downloadQueue.operations {
            if operation.name == identifier {
                operation.cancel()
            }
        }
    }
}


extension GANetwork{
    func fetchGeoLocation(param:[String: Any]?, success _success: @escaping (Any?) -> Void, failure _failure: @escaping (NetworkError) -> Void) {
        let success: (Any?) -> Void = { person in
            DispatchQueue.main.async { _success(person) }
        }
        let _: (NetworkError) -> Void = { error in
            DispatchQueue.main.async { _failure(error) }
        }
        let url = String(format: "%@%@",APIConstant.GetGeolocation.urlString,GoogleAPIKey.kApiKei)
        let requestModel = NetworkRequestModel(url: url,
                                               taskIdentifier: APIConstant.GetGeolocation.identifier,
                                               httpMethod: .POST,
                                               body: param,
                                               headers: [APIHeadersKeyAndValue.kContentType:APIHeadersKeyAndValue.kApplicationJOSN])
        let networkOperation = NetworkOperation(model: requestModel) { (model, data, response, error, statusCode, isSuccess) in
            if isSuccess {
                guard let data = data else{
                    print("no valid data found")
                    return
                }
                let json = JSON(data)
                CoreDataManager.saveGeoLocationData(json: json)
                print(json)
                success(json)
            } else {
                print("no valid data found")
            }
        }
        downloadQueue.addOperations([networkOperation], waitUntilFinished: false)
    }
    
    func cancelGeoLocation() {
        GANetwork.shared.cancelOperation(identifier: APIConstant.GetGeolocation.identifier)
    }
    
}


