//
//  DeeplinkingManager.swift
//  DeepLinkingManager
//
//  Created by N.A Shashank on 29/11/18.
//  Copyright © 2018 Razorpay. All rights reserved.
//

import UIKit

protocol DeeplinkingManagerDelegate:class {
    func isValid(scheme:String?) -> Bool
    func handleSchemeWith(host:String?,path:String?,options:[UIApplication.OpenURLOptionsKey : Any])
    func failedToParseDeeplink(error:ErrorDescribable)
}

public protocol ErrorDescribable:Error {
    var localizedDescription:String {get}
}


enum DeeplinkingError:ErrorDescribable {
    case failedToParseDeeplink
    
    var localizedDescription: String {
        return "\(self)"
    }
}
    

class DeeplinkingManager {
    
    static let retainedInstance = DeeplinkingManager()
    
    private weak var delegate:DeeplinkingManagerDelegate?
    
    func parseDeeplink(url:URL,options:[UIApplication.OpenURLOptionsKey : Any]) {
        guard let unwrappedDelegate = delegate else{
            assertionFailure("could not get delegate instance")
            return
        }
        guard unwrappedDelegate.isValid(scheme: url.scheme) else{
            self.delegate?.failedToParseDeeplink(error: DeeplinkingError.failedToParseDeeplink)
            return
        }
        unwrappedDelegate.handleSchemeWith(host: url.host, path: url.path, options: options)
    }
    
    @discardableResult func initialize(delegate:DeeplinkingManagerDelegate) -> Bool {
        guard let _ = self.delegate else{
            self.delegate = delegate
            return true
        }
        return false
    }
    
    @discardableResult func deinitializeDelegate(delegate:DeeplinkingManagerDelegate) -> Bool {
        guard let unwrappedDelegate = self.delegate else{
            return true
        }
        guard unwrappedDelegate === self.delegate else{
            return false
        }
        return true
    }
    
}
