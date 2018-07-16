//
// NetworkOperation.swift
//  GoscaleAsignment
//
//  Created by TapashM on 14/07/18.
//  Copyright © 2018 ITC Infotech. All rights reserved.
//



import Foundation

class NetworkOperation: AsyncOperation {
    
    fileprivate let model: NetworkRequestModel
    internal    let identifier: String
    fileprivate let completion: NetworkCompletionHandler
    
    init(model: NetworkRequestModel, completion: @escaping NetworkCompletionHandler) {
        self.model = model
        self.identifier = model.taskIdentifier
        self.completion = completion
    }
    
    override func main() {
        if self.isCancelled { return }
        self.qualityOfService = .userInitiated
        self.queuePriority = .high
        self.name = identifier
        ReachabilityManager.shared.httpCall(model: model) { (model, data, response, error, statusCode, isSuccess) in
            if self.isCancelled {
                return
            }
            self.completion(model, data, response, error, statusCode, isSuccess)
            self.state = .Finished
        }
    }
    
    override func cancel() {
        DispatchQueue.main.async {
            ReachabilityManager.shared.cancelHttpCall(identifier: self.identifier)
            self.state = .Finished
            print("Cancelling operation name: - \(self.identifier)")
        }
    }
}
