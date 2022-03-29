//
//  ViewController.swift
//  BioAuth
//
//  Created by Bear Cahill on 7/8/19.
//  Copyright © 2019 Bear Cahill. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        context.localizedCancelTitle = "My Cancel"
        context.localizedFallbackTitle = ""
        context.localizedReason = "The app needs your authentication."
        context.touchIDAuthenticationAllowableReuseDuration = LATouchIDAuthenticationMaximumAllowableReuseDuration
        evaluatePolicy()
    }

    func evaluatePolicy(){
        var errorCanEval:NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &errorCanEval) {
            
            switch context.biometryType {
            case.faceID:
                print("face")
            case.touchID:
                print("touch")
            case.none:
                print("none")
            @unknown default:
                print("unknown")
            }
            
           context.evaluatePolicy(.deviceOwnerAuthentication,                   localizedReason: "Fallback title  - override reason") {  (success, error) in
                print(success)
               
                if let err = error{
                    let evalErrCode = LAError(_nsError: err as NSError)
                    switch evalErrCode.code{
                    case LAError.Code.userCancel:
                        print("user cancelled")
                    case LAError.Code.userFallback:
                        print("Fallback")
                    case LAError.Code.authenticationFailed:
                        print("Failed")
                    default:
                        print("other error")
                    }
                }
               
                 
                }
            
        }else{
            print("Can't evaluate")
            print(errorCanEval?.localizedDescription ?? "no error desc")
            if let err = errorCanEval{
                let evalErrCode = LAError(_nsError: err as NSError)
                switch evalErrCode.code{
                case LAError.Code.userCancel:
                    print("not Enrolled")
                default:
                    print("other error")
                }
        }
        
    }
}
}
