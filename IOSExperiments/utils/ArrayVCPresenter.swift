//
//  ArrayVCPresenter.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 06.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//


class ArrayVCPresenter{
    //public
    func dismiss(to rootVc:UIViewController,animated: Bool = false,completion: (() -> Swift.Void)? = nil){
        viewcontrollers = []
        self.animated = animated
        self.rootVc = rootVc
        self.completion = completion
        fillArrayOfPresentedVCRecursively()
    }
    func present(array:[UIViewController],from rootVc:UIViewController,animated: Bool = false,completion: (() -> Swift.Void)? = nil){
        viewcontrollers = array
        self.animated = animated
        self.rootVc = rootVc
        self.completion = completion
        presenterVCIndex = -1
        presentArrayRecursively()
    }
    
    //private
    private var
    animated = false,
    presenterVCIndex = -1,
    completion: (() -> Swift.Void)?,
    viewcontrollers = [UIViewController](),
    rootVc:UIViewController!
    
    private func presentArrayRecursively(){
        let
        presenter = viewcontrollers[safe:presenterVCIndex] ?? rootVc,
        presented = viewcontrollers[safe:presenterVCIndex + 1]
        if
            let presented = presented,
            let presenter = presenter,
            presenter.presentedViewController == nil {
            presenterVCIndex += 1
            presenter.present(presented, animated: animated){[weak self]_ in self?.presentArrayRecursively()}
        } else {
            completion?()
            presenterVCIndex = -1
            viewcontrollers = []
            rootVc = nil
        }
    }
    private func fillArrayOfPresentedVCRecursively(){
        if viewcontrollers.isEmpty && rootVc.presentedViewController == nil {
            dismissArrayRecursively()
            return
        }
        
        let
        vc = viewcontrollers.last ?? rootVc
        if let presentedViewController = vc?.presentedViewController{
            viewcontrollers.append(presentedViewController)
            fillArrayOfPresentedVCRecursively()
        } else {
            viewcontrollers.reverse()
            dismissArrayRecursively()
        }
        
    }
    private func dismissArrayRecursively(){
        print(viewcontrollers)
        if let topVc = viewcontrollers.first{
            viewcontrollers.removeFirst()
            topVc.dismiss(animated: animated){[weak self]_ in self?.dismissArrayRecursively()}
        } else {
            completion?()
            viewcontrollers = []
            self.rootVc = nil
        }
        
    }
}
