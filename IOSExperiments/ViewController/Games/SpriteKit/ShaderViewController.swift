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
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            scene.setShader(shader: .Triangulation)
        case 2:
            scene.setShader(shader: .SHKWater)
        case 3:
            scene.setShader(shader: .NoShader)
        default:
            scene.setShader(shader: .PsychedelicGlass)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.layer.borderColor = UIColor.black.cgColor
        sceneView.layer.borderWidth = 1
        textView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        updateSpriteOfUnderlyingView()
    }
    
    
    
    //MARK: shader
    private var busy = false
    private var scene:ShaderScene{return sceneView.scene as! ShaderScene}
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
        scene.setTextureImage(cgImage: cgImage)
    }
}

extension ShaderViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSpriteOfUnderlyingView()
    }
}
