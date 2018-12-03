//
//  DeeplinkingManager.swift
//  DeepLinkingManager
//
//  Created by N.A Shashank on 29/11/18.
//  Copyright © 2018 Razorpay. All rights reserved.
//

import UIKit

protocol DeeplinkingManagerDelegate:class {
//    func isValid(scheme:String?) -> Bool
    func handleSchemeWith(host:String?,path:String?,options:[UIApplication.OpenURLOptionsKey : Any])
    //func failedToParseDeeplink(error:ErrorDescribable)
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
    

class DeeplinkingManager:DeeplinkCredentialManagerDelegate {
    
    static let retainedInstance = DeeplinkingManager()
    
    var deeplinkingCredentialsManager = DeeplinkCredentialManager()
    
    init() {
        self.deeplinkingCredentialsManager.delegate = self
    }
    
    func parseDeeplink(url:URL,options:[UIApplication.OpenURLOptionsKey : Any]) {
        self.deeplinkingCredentialsManager.handleSchemeWith(host: url.host, path: url.path, options: options)
    }
    
    func key() -> String {
        return self.deeplinkingCredentialsManager.valueFrom(keyPath: \DeeplinkCredentialManager.key, defaultValue: String())
    }
    
    func failedToParseUrl(error: DeeplinkingError) {
        assertionFailure("failed to parse url")
    }
    
}
