//
//  TouchIdHelper.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 05.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import LocalAuthentication
class ToudchIdHelper{
    var
    context:LAContext!
    typealias ToudchIdHandler = ((TouchIdCases)->())
    
    var isAvailable: Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    func login(_ handler:@escaping ToudchIdHandler){
        context = LAContext()
        context.localizedFallbackTitle = nil
        if isAvailable {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "TOUCH_ID_REASON".localized) { success, error in
                DispatchQueue.main.async{
                    if success{
                        handler(.success)
                        return
                    } else if
                        let codeRaw = (error as NSError?)?.code,
                        let errorCode = LAError.Code(rawValue:codeRaw){
                        switch errorCode {
                        case .authenticationFailed,
                             .invalidContext,
                             .touchIDLockout,
                             .touchIDNotAvailable,
                             .touchIDNotEnrolled,
                             .notInteractive:
                            handler(.fail)
                        case .appCancel,
                             .systemCancel,
                             .userCancel:
                            handler(.cancel)
                        case .userFallback,
                             .passcodeNotSet:
                            handler(.fallback)
                        }
                    } else {
                        handler(.fail)
                    }
                }
            }
        } else{
            handler(.fail)
        }
    }
    
    
    enum TouchIdCases{
        case
        success,
        cancel,
        fail,
        fallback
    }
}
