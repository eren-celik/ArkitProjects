//
//  TargetShooting.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import Foundation
import UIKit
import SceneKit
import ARKit

enum BoxBodyType : Int {
    case bullet = 1
    case barrier = 2
}

class TargetShootingGameViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    var sceneView = ARSCNView(frame: screenBounds)
    var lastContactNode :SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        let box1 = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        box1.materials = [material]
        
        let box2 = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.red
        
        box2.materials = [material2]
        
        let box3 = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material3 = SCNMaterial()
        material3.diffuse.contents = UIColor.red
        
        box3.materials = [material3]
        
        
        
        let box1Node = SCNNode(geometry: box1)
        box1Node.name = "Barrier1"
        box1Node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        box1Node.physicsBody?.categoryBitMask = BoxBodyType.barrier.rawValue
        box1Node.position = SCNVector3(0,0,-0.8)
        
        let box2Node = SCNNode(geometry: box2)
        box2Node.name = "Barrier2"
        
        box2Node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        box2Node.physicsBody?.categoryBitMask = BoxBodyType.barrier.rawValue
        
        
        let box3Node = SCNNode(geometry: box3)
        box3Node.name = "Barrier3"
        
        box3Node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        box3Node.physicsBody?.categoryBitMask = BoxBodyType.barrier.rawValue
        
        
        box2Node.position = SCNVector3(-0.2,0,-0.8)
        box3Node.position = SCNVector3(0.2,0.2,-0.8)
        
        
        scene.rootNode.addChildNode(box1Node)
        scene.rootNode.addChildNode(box2Node)
        scene.rootNode.addChildNode(box3Node)
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        self.sceneView.scene.physicsWorld.contactDelegate = self
        
        registerGestureRecognizers()
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        var contactNode :SCNNode!
        
        if contact.nodeA.name == "Bullet" {
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        
        if self.lastContactNode != nil && self.lastContactNode == contactNode {
            return
        }
        
        self.lastContactNode = contactNode
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        
        self.lastContactNode.geometry?.materials = [material]
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shoot))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func shoot(recognizer :UIGestureRecognizer) {
        
        guard let currentFrame = self.sceneView.session.currentFrame else {
            return
        }
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.3
        
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "Bullet"
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.categoryBitMask = BoxBodyType.bullet.rawValue
        boxNode.physicsBody?.contactTestBitMask = BoxBodyType.barrier.rawValue
        boxNode.physicsBody?.isAffectedByGravity = false
        
        boxNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        
        let forceVector = SCNVector3(boxNode.worldFront.x * 2,boxNode.worldFront.y * 2,boxNode.worldFront.z * 2)
        
        boxNode.physicsBody?.applyForce(forceVector, asImpulse: true)
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
}



