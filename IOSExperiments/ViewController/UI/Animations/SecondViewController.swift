//
//  ViewController.swift
//  CircleTransition
//
//  Created by Rounak Jain on 23/10/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

import UIKit
import PocketSVG

class SecondViewController: UIViewController  {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var viewToDrawOn: UIView!
    @IBOutlet weak var imageToReveal: UIImageView!
    @IBOutlet weak var viewForDrawnig: UIView!
    
    let kAnimationDuration = 0.7
    
    override func viewDidAppear(_ animated: Bool) {
        triggerAnimations()
    }
    
    @IBAction func buttonTap(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    deinit {
        print("deinit \(type(of: self))", terminator: "")
    }
}

extension SecondViewController : ViewControllerWithButton{
    func getButton() -> UIView {
        return button
    }
}

extension SecondViewController {
    func triggerAnimations(){
        drawUserpicOutline()
        revealUserpic()
        animateView()
    }
    
    func drawUserpicOutline() {
        //The shape of the outline — circle, obviously
        let circle = CAShapeLayer()
        //It should cover the whole view, so...
        let radius: CGFloat = self.viewToDrawOn.frame.size.width / 2.0
        circle.position = CGPoint.zero
        circle.path = UIBezierPath(roundedRect: self.viewToDrawOn.bounds, cornerRadius: radius).cgPath
        //We set the stroke color and fill color of the shape
        circle.fillColor = UIColor.clear.cgColor
        //Don't freak out, I'm simply using a UIColor category that creates UIColor objects out of a string holding its hex value.
        circle.strokeColor = UIColor.red.cgColor
        circle.lineWidth = 5.0
        
        
        self.viewToDrawOn.layer.addSublayer(circle)
        //Here we create the animation itself, We're animating the end position of the stroke, which will gradually change from 0 to 1 (making a full circle)
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = kAnimationDuration
        drawAnimation.repeatCount = 1.0
        drawAnimation.fromValue = Int(0.0)
        drawAnimation.toValue = Int(1.0)
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circle.add(drawAnimation, forKey: "drawUserpicOutlineAnimation")
    }
    func revealUserpic() {
        //The initial and final radius' values of the shapes
        let initialRadius: CGFloat = 1.0
        let finalRadius: CGFloat = self.imageToReveal.bounds.size.width / 2.0
        //Creating the shape of revealing mask
        let revealShape = CAShapeLayer()
        revealShape.bounds = self.imageToReveal.bounds
        //We need to set the fill color to some — since it's a mask shape layer
        revealShape.fillColor = UIColor.black.cgColor
        //A set of two paths — the initial and final ones
        let
        roundedRect = CGRect(
            x: self.imageToReveal.bounds.midX - initialRadius,
            y: self.imageToReveal.bounds.midY - initialRadius,
            width: initialRadius * 2,
            height: initialRadius * 2
        ),
        
        startPath = UIBezierPath( roundedRect: roundedRect, cornerRadius: initialRadius),
        endPath = UIBezierPath(roundedRect: self.imageToReveal.bounds, cornerRadius: finalRadius)
        
        
        revealShape.path = startPath.cgPath
        revealShape.position = CGPoint(x: self.imageToReveal.bounds.midX - initialRadius, y: self.imageToReveal.bounds.midY - initialRadius)
        //So now we've masked the image, only the portion that is covered with the circle layer will be visible
        self.imageToReveal.layer.mask = revealShape
        //That's the animation. What we animate is the "path" property — from a tiny dot in the center of the image to a large filled circle covering the whole image.
        let revealAnimationPath = CABasicAnimation(keyPath: "path")
        revealAnimationPath.fromValue = ((startPath.cgPath) as AnyObject)
        revealAnimationPath.toValue = ((endPath.cgPath) as AnyObject)
        revealAnimationPath.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        revealAnimationPath.duration = kAnimationDuration / 2.0
        revealAnimationPath.repeatCount = 1.0
        //Set the begin time, so that the image starts appearing when the outline animation is already halfway through
        revealAnimationPath.beginTime = CACurrentMediaTime() + kAnimationDuration / 2.0
//        revealAnimationPath.delegate = self
        //Since we start the image reveal animation with a delay, we will need to wait to make the image visible as well
        let timeToShow = DispatchTime.now() + Double(Int64(kAnimationDuration / 2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: timeToShow, execute: {() -> Void in
            self.imageToReveal.isHidden = false
        })
        revealShape.path = endPath.cgPath
        revealShape.add(revealAnimationPath, forKey: "revealUserpicAnimation")
    }
    
    func animateView(){
        viewForDrawnig.alpha = 0
        viewForDrawnig.frame.origin.x =  -200
        
        viewForDrawnig.isHidden = false
        UIView.animate(
            withDuration: kAnimationDuration,
            animations: {[unowned self] in
                self.viewForDrawnig.alpha = 1
                self.viewForDrawnig.frame.origin.x = 0
            },
            completion: {[unowned self] _ in
                self.drawBeziers()
            }
        )
    }
    
}

extension SecondViewController {
    func drawBeziers(){
        animateBezier(getBezierPath(for: viewForDrawnig.bounds.size,file: "BezierCurve1"))
        animateBezier(generateBezierPath())        
    }
    
    
    func animateBezier(_ path:CGPath){
        let figure = CAShapeLayer()
        figure.position = CGPoint.zero
        //We set the stroke color and fill color of the shape
        figure.fillColor = UIColor.clear.cgColor
        //Don't freak out, I'm simply using a UIColor category that creates UIColor objects out of a string holding its hex value.
        figure.strokeColor = UIColor.black.cgColor
        figure.lineWidth = 2
        
        
        
        figure.path = path
        //= getBezierPath(for: viewForDrawnig.bounds.size,file: "BezierCurve1")
        //figure.path = generateBezierPath().CGPath
        
        viewForDrawnig.layer.addSublayer(figure)
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = kAnimationDuration
        drawAnimation.repeatCount = 1.0
        drawAnimation.fromValue = Int(0.0)
        drawAnimation.toValue = Int(1.0)
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        figure.add(drawAnimation, forKey: "drawUserpicOutlineAnimation")
        
    }
    func generateBezierPath() -> CGPath{
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 59, y: 44))
        bezierPath.addLine(to: CGPoint(x: 28, y: 44))
        bezierPath.addLine(to: CGPoint(x: 28, y: 23.05))
        bezierPath.addLine(to: CGPoint(x: 31.44, y: 18))
        bezierPath.addLine(to: CGPoint(x: 43.54, y: 18))
        bezierPath.addLine(to: CGPoint(x: 47.06, y: 22.25))
        bezierPath.addLine(to: CGPoint(x: 59, y: 22.25))
        bezierPath.addLine(to: CGPoint(x: 59, y: 44))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 30.28, y: 41.7))
        bezierPath.addLine(to: CGPoint(x: 56.64, y: 41.7))
        bezierPath.addLine(to: CGPoint(x: 56.64, y: 24.55))
        bezierPath.addLine(to: CGPoint(x: 45.94, y: 24.55))
        bezierPath.addLine(to: CGPoint(x: 42.42, y: 20.3))
        bezierPath.addLine(to: CGPoint(x: 32.68, y: 20.3))
        bezierPath.addLine(to: CGPoint(x: 30.32, y: 23.74))
        bezierPath.addLine(to: CGPoint(x: 30.32, y: 41.7))
        bezierPath.addLine(to: CGPoint(x: 30.28, y: 41.7))
        bezierPath.close()
        return bezierPath.cgPath
    }
    
    func getBezierPath(for containingSize:CGSize, file:String) -> CGPath {
        let url = Bundle.main.url(forResource: file, withExtension: "svg")
        
        
        let
        path = SVGBezierPath.pathsFromSVG(at: url!).first,
        boundingBox = path!.bounds
        let boundingBoxAspectRatio = boundingBox.width/boundingBox.height
        let viewAspectRatio = containingSize.width/containingSize.height
        let scaleFactor: CGFloat
        if (boundingBoxAspectRatio > viewAspectRatio) {
            // Width is limiting factor
            scaleFactor = containingSize.width / boundingBox.width
        } else {
            // Height is limiting factor
            scaleFactor = containingSize.height / boundingBox.height
        }
        var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let transformedPath = path!.cgPath.copy(using: &affineTransform)
        return transformedPath!
    }
    
}
