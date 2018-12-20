//
//  UIView.swift
//  iosExperiments
//
//  Created by 0x384c0 on 1/20/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
//import ObjectiveC
import EZSwiftExtensions

import AlamofireImage

let
ANIMATION_DURATION = 0.3,
IMAGE_ANIMATION_DURATION = 0.05

//MARK: generic
extension UIView {
    
    func setZeroHeigh(animated:Bool = false){
        let heighConstr = getConstrant(.height)
        if animated {
            UIView.animate(
                withDuration: ANIMATION_DURATION,
                animations: {[weak self, weak heighConstr] in
                    heighConstr?.constant = 0
                    self?.window?.layoutIfNeeded()
                },
                completion: { [weak self] _ in
                    self?.isHidden = true
                }
            )
            return
        }
        
        heighConstr.constant = 0
        
        isHidden = true
    }
    func getConstrant(_ attribute:NSLayoutConstraint.Attribute) -> NSLayoutConstraint{
        for constraint in constraints {
            if (constraint.firstAttribute == attribute) {
                return constraint
            }
        }
        
        let constrant = NSLayoutConstraint (
            item: self,
            attribute: attribute,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: bounds.height
        )
        addConstraint(constrant)
        constrant.isActive = true
        return constrant
    }
    
    func shake4Times() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    func rotate(by:CGFloat){
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {[weak self] in
            if let transform = self?.transform{
                self?.transform = transform.rotated(by: 2 * CGFloat.pi / (360.0/by))
            }
        })
    }
    func setAngle(_ angle:CGFloat,animated:Bool = true){
        if animated{
            UIView.animate(withDuration: ANIMATION_DURATION, animations: {[weak self] in
                self?.transform = CGAffineTransform(rotationAngle:  2 * CGFloat.pi / (360.0/angle))
            })
        } else {
            transform = CGAffineTransform(rotationAngle:  2 * CGFloat.pi / (360.0/angle))
        }
    }
}

extension UITableViewCell{
    static var reuseId:String {
        return className
    }
}

extension UIViewController{
    
    static var segueID:String {
        return className
    }
    
    func getVCfromSB(storyBoardID:String, viewControllerID:String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyBoardID, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: viewControllerID)
    }
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @discardableResult
    func popToSelf(animated: Bool = true) -> [UIViewController]{
        return navigationController?.popToViewController(self, animated: animated) ?? []
    }
}


extension UIScrollView {// Dont disable scrolling
    func didRotateScreen(){
        if frame.height != 0 {
            setHeighByContent(animated: true)
        }
    }
    func setHeighByContent(animated:Bool = false) {
        let heighConstr = getConstrant(.height)
        isHidden = false
        if animated {
            UIView.animate(
                withDuration: ANIMATION_DURATION,
                animations: {[weak self] in
                    heighConstr.constant = self?.contentSize.height ?? 0
                    self?.window?.layoutIfNeeded()
                },
                completion: {[weak self] bool in
                    heighConstr.constant = self?.contentSize.height ?? 0
                }
            )
            return
        }
        heighConstr.constant = contentSize.height
        
    }
    func toggleHeigh(animated:Bool = false) -> Bool{//Returuns - will be shown
        if frame.height == 0 {
            setHeighByContent(animated: animated)
            return true
        } else {
            setZeroHeigh(animated: animated)
            return false
        }
    }
    func scrollToBottom(animated:Bool = false){
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    func scrollToTop(animated:Bool = false){
        let bottomOffset = CGPoint(x: 0, y: 0)
        setContentOffset(bottomOffset, animated: animated)
    }
    func scroll(by:CGFloat,animated:Bool = false){
        let contentOffset = CGPoint(x:self.contentOffset.x,y:self.contentOffset.y + by)
        setContentOffset(contentOffset, animated: animated)
    }
}

extension UIWebView{
    func setHeighByContent(animated:Bool = false) {
        let heighConstr = getConstrant(.height)
        isHidden = false
        if animated {
            UIView.animate(
                withDuration: ANIMATION_DURATION,
                animations: {[weak self] in
                    heighConstr.constant = self?.scrollView.contentSize.height ?? 0
                    self?.window?.layoutIfNeeded()
                },
                completion: {[weak self] bool in
                    heighConstr.constant = self?.scrollView.contentSize.height ?? 0
                }
            )
            return
        }
        heighConstr.constant = scrollView.contentSize.height
        
    }
    func toggleHeigh(animated:Bool = false) -> Bool{//Returuns - will be shown
        if frame.height == 0 {
            setHeighByContent(animated: animated)
            return true
        } else {
            setZeroHeigh(animated: animated)
            return false
        }
    }
}

extension UIRefreshControl {
    func beginRefreshingProgrammatically(){
        if !isRefreshing {
            if let scrollView = superview as? UIScrollView {
                scrollView.setContentOffset(
                    CGPoint(x: 0, y: scrollView.contentOffset.y - frame.size.height),
                    animated: true
                )
            }
            beginRefreshing()
        }
    }
}

extension UITableView {
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {[weak self] in
            if let
                numberOfSections = self?.numberOfSections,
                let numberOfRows = self?.numberOfRows(inSection: numberOfSections-1)
                ,
                numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self?.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
            
        })
    }
    func scrolToSelectedCell(atScrollPosition scrollPosition: UITableView.ScrollPosition = .middle){
        if let indexPathForSelectedRow = indexPathForSelectedRow {
            scrollToRow(at: indexPathForSelectedRow, at: scrollPosition, animated: true)
        }
    }
    func clearSelection() {
        for indexPath in indexPathsForSelectedRows ?? [] {
            deselectRow(at: indexPath, animated: true)
        }
    }
}

extension UILabel {
    var textInt:Int?{
        set{
            text = (newValue != nil && newValue != 0) ? String(newValue ?? 0) : nil
        }
        get{
            return Int(text ?? "")
        }
    }
    func setAttributedTextOrHideView(_ text:NSAttributedString?, viewToHide:UIView? = nil){
        var text = text
        let rowIsEmpty = text?.string.isBlank ?? true
        
        text = rowIsEmpty ? nil : text
        if let attributedText = text {
            self.attributedText = attributedText
        } else {
            viewToHide?.setZeroHeigh()
            setZeroHeigh()
        }
    }
    func setTextOrHideView( _ text:String?, viewToHide:UIView? = nil){
        
        var text = text
        let rowIsEmpty = text?.isBlank ?? true
        text = rowIsEmpty ? nil : text
        if let text = text {
            self.text = text
        } else {
            viewToHide?.setZeroHeigh()
            setZeroHeigh()
        }
    }
}

extension UITextView{
    func setAttributedTextOrHideView(_ text:NSAttributedString?, viewToHide:UIView? = nil ,SetHeighByContent:Bool = true) -> Bool{
        
        var text = text
        let rowIsEmpty = (text?.string.isBlank ?? true) || text?.string.trimmingCharacters(in: .whitespacesAndNewlines) == "--"
        
        text = rowIsEmpty ? nil : text
        if let attributedText = text {
            self.attributedText = attributedText
            if SetHeighByContent {
                setHeighByContent()
            }
            return true
        } else {
            viewToHide?.setZeroHeigh()
            setZeroHeigh()
            return false
        }
    }
    func setTextOrHideView( _ text:String?, viewToHide:UIView? = nil ,SetHeighByContent:Bool = true){
        
        var text = text
        let rowIsEmpty = text?.isBlank ?? true
        text = rowIsEmpty ? nil : text
        if let text = text {
            self.text = text
            if SetHeighByContent {
                setHeighByContent()
            }
        } else {
            viewToHide?.setZeroHeigh()
            setZeroHeigh()
        }
    }
}

extension UIImage {
    func getTintedImage(_ color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        context!.scaleBy(x: 1.0, y: -1.0)
        context!.translateBy(x: 0.0, y: -size.height)
        
        // multiply blend mode
        context!.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context!.clip(to: rect, mask: cgImage!)
        color.setFill()
        context!.fill(rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    func resizeImage(_ size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
extension UIImageView{
    func af_loadImage(from imageUrlString:String?,placeholderImage: UIImage? = nil){
        if
            let imageUrlString = imageUrlString,
            let imageUrl = URL(string:imageUrlString){
            af_setImage(
                withURL:imageUrl,
                placeholderImage: placeholderImage,
                imageTransition: .crossDissolve(IMAGE_ANIMATION_DURATION),
                runImageTransitionIfCached: false
            )
        } else {
            image = placeholderImage ?? UIImage(named: Constants.PLACEHOLDER_IMAGE)
        }
    }
    
    func af_loadImage(from imageUrlString:String?,with previewImageUrlString:String){
        let
        imageUrl  = imageUrlString == nil               ? nil : URL(string:imageUrlString!),
        preivewUrl = URL(string:previewImageUrlString)
        if imageUrl != nil && preivewUrl != nil{
            let
            imageDownloader = af_imageDownloader ?? UIImageView.af_sharedImageDownloader,
            imageCache = imageDownloader.imageCache
            
            if let//если картинка originalImage уже есть в кеше, то не грузить preivewImage, а сразу originalImage
                imageUrl = imageUrl,
                let _ = imageCache?.image(for: URLRequestWithURL(imageUrl),withIdentifier: nil) {
                af_setImage(
                    withURL:imageUrl,
                    imageTransition: .crossDissolve(IMAGE_ANIMATION_DURATION),
                    runImageTransitionIfCached: false
                )
                
                return
            }
            //load with preview
            af_setImage(
                withURL: preivewUrl!,
                placeholderImage: UIImage(named: Constants.PLACEHOLDER_IMAGE),
                imageTransition: .crossDissolve(IMAGE_ANIMATION_DURATION),
                runImageTransitionIfCached: false,
                completion: {[weak self] respone in
                    if let imageUrl = imageUrl {
                        self?.af_setImage(
                            withURL: imageUrl,
                            placeholderImage: UIImage(named: Constants.PLACEHOLDER_IMAGE),
                            imageTransition: .crossDissolve(IMAGE_ANIMATION_DURATION),
                            runImageTransitionIfCached: false,
                            completion:nil
                        )
                    }
                }
            )
            
            return
            
        }
        
        image = UIImage(named: Constants.PLACEHOLDER_IMAGE)
    }
    fileprivate func URLRequestWithURL(_ URL: Foundation.URL) -> URLRequest {
        
        let acceptableImageContentTypes: Set<String> = [
            "image/tiff",
            "image/jpeg",
            "image/gif",
            "image/png",
            "image/ico",
            "image/x-icon",
            "image/bmp",
            "image/x-bmp",
            "image/x-xbitmap",
            "image/x-win-bitmap"
        ]
        let mutableURLRequest = NSMutableURLRequest(url: URL)
        
        for mimeType in acceptableImageContentTypes {
            mutableURLRequest.addValue(mimeType, forHTTPHeaderField: "Accept")
        }
        
        return mutableURLRequest as URLRequest
    }
}
