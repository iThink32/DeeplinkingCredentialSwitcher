//
//  DeeplinkCredentialManager.swift
//  DeepLinkingManager
//
//  Created by N.A Shashank on 29/11/18.
//  Copyright © 2018 Razorpay. All rights reserved.
//

import UIKit

protocol DeeplinkCredentialManagerDelegate: class {
    func failedToParseUrl(error:DeeplinkingError)
}

class DeeplinkCredentialManager:DeeplinkingManagerDelegate {
    
    private var razorpayType:RazorpayType?
    var key:String?
    
    weak var delegate:DeeplinkCredentialManagerDelegate?
    
    enum RazorpayType {
        case checkout(Mode)
        case customui(Mode)
        
        static func instanceFrom(host:String,path:String) -> RazorpayType {
            // since checkout and custom ui are using the same keys there is a common mode but in future
            // if it splits change it here
            var mode:Mode
            switch path {
            case let strTemp where strTemp.contains("live") :
                mode = DeeplinkCredentialManager.Mode.live(Credentials.liveKey.rawValue)
            case let strTemp where strTemp.contains("debug") :
                mode = DeeplinkCredentialManager.Mode.debug(Credentials.debugKey.rawValue)
            case let strTemp where strTemp.contains("partner") :
                mode = DeeplinkCredentialManager.Mode.partner(Credentials.partnerKey.rawValue)
            default :
                mode = DeeplinkCredentialManager.Mode.custom(path)
            }
            guard host.lowercased() == "checkout" else{
                return RazorpayType.customui(mode)
            }
            return RazorpayType.checkout(mode)
        }
        
        var key:String {
            var strTemp = String()
            switch self {
            case RazorpayType.checkout(let mode) :
                strTemp = mode.key
            case RazorpayType.customui(let mode) :
                strTemp = mode.key
            }
            return strTemp
        }
        
    }
    
    enum Mode {
        case live(String)
        case debug(String)
        case partner(String)
        case custom(String)
        
        var key :String {
            var tmpKey = String()
            switch self {
            case Mode.live(let path),Mode.debug(let path),Mode.partner(let path) :
                tmpKey = path
            case Mode.custom(let path) :
                tmpKey = self.keyFromCustomMode(str: path)
            }
            return tmpKey
        }
        
        func keyFromCustomMode(str:String) -> String {
            var arrComponents = str.components(separatedBy: "&")
            guard arrComponents.count >= 2 else {
                return String()
            }
            let path = arrComponents[1]
            let arrRequiredComponents = path.components(separatedBy: "=")
            guard arrRequiredComponents.count >= 2 else{
                return String()
            }
            return arrRequiredComponents[1]
        }
        
    }
    
    func handleSchemeWith(host: String?, path: String?, options: [UIApplication.OpenURLOptionsKey : Any]) {
        guard let unwrappedHost = host,let unwrappedPath = path else{
            self.delegate?.failedToParseUrl(error: DeeplinkingError.failedToParseDeeplink)
            return
        }
        let type = RazorpayType.instanceFrom(host: unwrappedHost, path: unwrappedPath)
        self.razorpayType = type
        self.key = type.key
    }
    
    func valueFrom<ReturnType,Type>(keyPath:KeyPath<DeeplinkCredentialManager,Type>,defaultValue:ReturnType) -> ReturnType {
        let value = self[keyPath:keyPath]
        
        let mirror = Mirror(reflecting: value)
        guard mirror.displayStyle == Mirror.DisplayStyle.optional,mirror.children.count == 1,let child = mirror.children.first?.value as? ReturnType else{
            return defaultValue
        }
        return child
    }
    
    deinit {
        print("\(#file) deallocated")
    }
    
}
