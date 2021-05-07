//
//  Portal.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import UIKit
import SceneKit
import ARKit

class PortalViewController: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView(frame: UIScreen.main.bounds)
    var planes :[Plane] = [Plane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
         registerGestureRecognizers()
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !hitTestResults.isEmpty {
            
            let hitTestResult = hitTestResults.first!
            addPortal(ht :hitTestResult)
            
        }
    }
    
    // this function adds the portal model to the real world
    private func addPortal(ht :ARHitTestResult) {
        
        let portalScene = SCNScene(named: "art.scnassets/ship.scn")!
        let portalNode = (portalScene.rootNode.childNode(withName: "portalNode", recursively: true))!
        
        portalNode.position = SCNVector3(ht.worldTransform.columns.3.x, ht.worldTransform.columns.3.y, ht.worldTransform.columns.3.z)
        
        self.sceneView.scene.rootNode.addChildNode(portalNode)
        
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !(anchor is ARPlaneAnchor) {
            return
        }
        
        let plane = Plane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first
        
        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    

}
