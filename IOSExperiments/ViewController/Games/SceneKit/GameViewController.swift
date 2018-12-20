//
//  GameViewController.swift
//  Experiments-SceneKit
//
//  Created by Andrew Ashurov on 9/26/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion

class GameViewController: UIViewController {
    @IBOutlet weak var scnView: SCNView!
    weak var cameraNode:SCNNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScene()
        self.setupMotion()
    }
    
    func setupScene(){
        // set the scene to the view
        scnView.scene =  SCNScene(named: "art.scnassets/ship.scn")!
        scnView.showsStatistics = true
        
        cameraNode = scnView.scene!.rootNode.childNode(withName: "camera", recursively: false)!
        
        let plane = scnView.scene!.rootNode.childNode(withName: "plane", recursively: false)!
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        plane.constraints = [billboardConstraint]
    }
    
    var
    motionManager = CMMotionManager(),
    initialAttitude:CMAttitude!
    func setupMotion(){
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main) { (motion, error) in
            if let motion = motion {
                self.cameraNode.orientation = motion.gaze(atOrientation: .portrait)
            }
        }
    }
}


extension CMDeviceMotion {
    
    func gaze(atOrientation orientation: UIInterfaceOrientation) -> SCNVector4 {
        
        let attitude = self.attitude.quaternion
        let aq = GLKQuaternionMake(Float(attitude.x), Float(attitude.y), Float(attitude.z), Float(attitude.w))
        
        let final: SCNVector4
        
        switch orientation {
            
        case .landscapeRight:
            
            let cq = GLKQuaternionMakeWithAngleAndAxis(Float.pi/2, 0, 1, 0)
            let q = GLKQuaternionMultiply(cq, aq)
            
            final = SCNVector4(x: -q.y, y: q.x, z: q.z, w: q.w)
            
        case .landscapeLeft:
            
            let cq = GLKQuaternionMakeWithAngleAndAxis(-Float.pi/2, 0, 1, 0)
            let q = GLKQuaternionMultiply(cq, aq)
            
            final = SCNVector4(x: q.y, y: -q.x, z: q.z, w: q.w)
            
        case .portraitUpsideDown:
            
            let cq = GLKQuaternionMakeWithAngleAndAxis(Float.pi/2, 1, 0, 0)
            let q = GLKQuaternionMultiply(cq, aq)
            
            final = SCNVector4(x: -q.x, y: -q.y, z: q.z, w: q.w)
            
        case .unknown:
            
            fallthrough
            
        case .portrait:
            
            let cq = GLKQuaternionMakeWithAngleAndAxis(-Float.pi/2, 1, 0, 0)
            let q = GLKQuaternionMultiply(cq, aq)
            
            final = SCNVector4(x: q.x, y: q.y, z: q.z, w: q.w)
        }
        
        return final
    }
}
