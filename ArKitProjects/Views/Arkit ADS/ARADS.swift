//
//  ARADS.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//


import UIKit
import SceneKit
import ARKit

class ARADSViewController: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView(frame: screenBounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARImageAnchor {
            
            DispatchQueue.global().async {
                
                let phoneScene = SCNScene(named: "Helper/Phone_01.scn")!
                let phoneNode = phoneScene.rootNode.childNode(withName: "parentNode", recursively: true)!
                
                DispatchQueue.main.async
                    {
                        
                    // rotate the phone node
                    let rotationAction = SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1)
                    let inifiniteAction = SCNAction.repeatForever(rotationAction)
                    phoneNode.runAction(inifiniteAction)
                    
                    phoneNode.position = SCNVector3(anchor.transform.columns.3.x,anchor.transform.columns.3.y + 0.1,anchor.transform.columns.3.z)
                    
                    node.addChildNode(phoneNode)
                }
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        configuration.trackingImages = referenceImages
        
        //configuration.detectionImages = referenceImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}
