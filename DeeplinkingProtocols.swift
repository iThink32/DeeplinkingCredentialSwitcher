//
//  DeeplinkingProtocols.swift
//  SampleAppCheckout
//
//  Created by N.A Shashank on 03/12/18.
//

import UIKit

protocol DeeplinkCredentialManagerDelegate: class {
    func failedToParseUrl(error:DeeplinkingError)
}

protocol DeeplinkingManagerDelegate:class {
    func handleSchemeWith(host:String?,path:String?,options:[UIApplication.OpenURLOptionsKey : Any])
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
