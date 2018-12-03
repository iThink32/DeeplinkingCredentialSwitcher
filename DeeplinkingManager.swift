//
//  DeeplinkingManager.swift
//  DeepLinkingManager
//
//  Created by N.A Shashank on 29/11/18.
//

import UIKit
    
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
