//
//  ShaderViewController.swift
//  IOSExperiments
//
//  Created by Andrew Ashurov on 12/20/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import SpriteKit

class ShaderViewController: UIViewController {

    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.layer.borderColor = UIColor.black.cgColor
        sceneView.layer.borderWidth = 1
        textView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateSpriteOfUnderlyingView()
    }
    
    private var busy = false
    private func updateSpriteOfUnderlyingView(){
        if busy {return}
        DispatchQueue.global(qos: .background).async {
            self.busy = true
            let image = self.getImageFromRootView()
            DispatchQueue.main.async {
                self.setImageToSceneView(image:image)
            }
            self.busy = false
        }
    }
    private func getImageFromRootView() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(rootView.bounds.size, false, 0)
        rootView.drawHierarchy(in: rootView.bounds, afterScreenUpdates:false)//TODO: find faster way to render view
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    private func setImageToSceneView(image:UIImage){
        //        var rect = rootView.convert(rootView.frame, to: sceneView)
        let rect = sceneView.frame
        let rectRetina = CGRect(
            x: rect.x * UIScreen.main.scale,
            y: rect.y * UIScreen.main.scale,
            w: rect.w * UIScreen.main.scale,
            h: rect.h * UIScreen.main.scale)
        let cgImage = image.cgImage!.cropping(to: rectRetina)!
        (sceneView.scene as! ShaderScene).setTextureImage(cgImage: cgImage)
    }
}

extension ShaderViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSpriteOfUnderlyingView()
    }
}
