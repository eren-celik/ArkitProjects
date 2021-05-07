//
//  Reflections.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import UIKit
import SceneKit
import ARKit

class ReflectionsViewController: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView(frame: screenBounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        registerGestureRecognizers()
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            print("Plane is detected")
        } else if anchor is AREnvironmentProbeAnchor {
            return
        }
        else {
            
            let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
            
            let material = SCNMaterial()
            material.lightingModel = .physicallyBased
            material.diffuse.contents = UIColor.purple
            material.metalness.contents = UIImage(named :"Helper/streakedmetal-metalness")
            material.roughness.contents = UIImage(named :"Helper/streakedmetal-roughness")
            
            box.materials = [material]
            
            let boxNode = SCNNode(geometry: box)
            boxNode.position.y = 0.2/2
            
            node.addChildNode(boxNode)
            
        }
        
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        let sceneView = recognizer.view as! ARSCNView
        let touch = recognizer.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touch, types: .existingPlane)
        
        if !hitTestResults.isEmpty {
            
            let hitTestResult = hitTestResults.first!
            
            let anchor = ARAnchor(name: "box", transform: hitTestResult.worldTransform)
            
            self.sceneView.session.add(anchor: anchor)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}

