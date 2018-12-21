//
//  ShaderScene.swift
//  IOSExperiments
//
//  Created by Andrew Ashurov on 12/21/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import SpriteKit

class ShaderScene: SKScene {
    var imageNode:SKSpriteNode!
    var effectNode:SKEffectNode!
    override func didMove(to view: SKView) {
        imageNode = childNode(withName: "imageNode") as? SKSpriteNode
        
//        let uniforms: [SKUniform] = [
//            SKUniform(name: "u_speed", float: 3),
//            SKUniform(name: "u_strength", float: 2.5),
//            SKUniform(name: "u_frequency", float: 10)
//        ]
//        let waterShader = SKShader(fromFile: "SHKWater", uniforms: uniforms)
//        imageNode.shader = waterShader
        imageNode.shader = SKShader(fromFile: "Triangulation")
        
        
        imageNode.size = frame.size
    }
    
    
    
    func setTextureImage(cgImage:CGImage){
        imageNode.texture = SKTexture(cgImage: cgImage)
    }
}


fileprivate extension SKShader {
    /**
     Convience initializer to create a shader from a filename by way of a string.
     Although this approach is less efficient than loading directly from disk, it enables
     shader errors to be printed in the Xcode console.
     
     - Parameter filename: A filename in your bundle, including extension.
     - Parameter uniforms: An array of SKUniforms to apply to the shader. Defaults to nil.
     - Parameter attributes: An array of SKAttributes to apply to the shader. Defaults to nil.
     */
    convenience init(fromFile filename: String, uniforms: [SKUniform]? = nil, attributes: [SKAttribute]? = nil) {
        // it is a fatal error to attempt to load a missing or corrupted shader
        guard let path = Bundle.main.path(forResource: filename, ofType: "fsh") else {
            fatalError("Unable to find shader \(filename).fsh in bundle")
        }
        
        guard let source = try? String(contentsOfFile: path) else {
            fatalError("Unable to load shader \(filename).fsh")
        }
        
        // if we were sent any uniforms then apply them immediately
        if let uniforms = uniforms {
            self.init(source: source as String, uniforms: uniforms)
        } else {
            self.init(source: source as String)
        }
        
        // if we were sent any attributes then apply those too
        if let attributes = attributes {
            self.attributes = attributes
        }
    }
}
