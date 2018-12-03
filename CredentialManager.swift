//
//  CredentialManager.swift
//  DeepLinkingManager
//
//  Created by N.A Shashank on 29/11/18.
//  Copyright © 2018 Razorpay. All rights reserved.
//

import UIKit

class CredentialManager:DeeplinkingManagerDelegate {
    
   var mode:Mode?
   var key:String?
    
    enum Mode {
        case live
        case debug
        case custom(String)
        
        var key :String {
            var tmpKey = String()
            switch self {
            case Mode.live :
                tmpKey = "live"
            case Mode.debug :
                tmpKey = "debug"
            case Mode.custom(let path) :
                tmpKey = keyFromCustomMode(str: path)
            }
            return tmpKey
        }
        
        func keyFromCustomMode(str:String) -> String {
            var arrComponents = str.components(separatedBy: "=")
            guard arrComponents.count >= 2 else {
              return String()
            }
            return arrComponents[1]
        }
        
        static func instanceFrom(str:String,path:String?) -> CredentialManager.Mode {
            let caseInsensitiveString = str.lowercased()
            var instance:CredentialManager.Mode
            switch caseInsensitiveString {
            case "live" :
                instance = CredentialManager.Mode.live
            case "debug" :
                instance = CredentialManager.Mode.debug
            default :
                instance = CredentialManager.Mode.custom(path ?? String())
            }
            return instance
        }
        
    }
    
    func isValid(scheme: String?) -> Bool {
        return scheme == "razorpay"
    }
    
    func handleSchemeWith(host: String?, path: String?, options: [UIApplication.OpenURLOptionsKey : Any]) {
        guard let unwrappedHost = host else{
            assertionFailure("could not parse host")
            return
        }
        let mode = CredentialManager.Mode.instanceFrom(str: unwrappedHost, path: path)
        self.mode = mode
        self.key = mode.key
        
    }
    
    func valueFrom<ReturnType,Type>(keyPath:KeyPath<CredentialManager,Type>,defaultValue:ReturnType) -> ReturnType {
        let value = self[keyPath:keyPath]
        
        let mirror = Mirror(reflecting: value)
        guard mirror.displayStyle == Mirror.DisplayStyle.optional,mirror.children.count == 1,let child = mirror.children.first?.value as? ReturnType else{
            return defaultValue
        }
        return child
    }
    
    func failedToParseDeeplink(error: ErrorDescribable) {
        assertionFailure("could not parse deep link")
    }
    
}
