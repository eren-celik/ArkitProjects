//
//  AddingMultipleItem.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 6.05.2021.
//

import UIKit
import SceneKit
import ARKit


class AddingMultipleItemViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView = ARSCNView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(sceneView)
        
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        // material.diffuse.contents = UIImage(named: "wood.jpeg")
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0, 0, -0.5)
        boxNode.geometry?.materials = [material]
        
        let sphere = SCNSphere(radius: 0.3)
        sphere.firstMaterial?.diffuse.contents = UIColor.green
        //        sphere.firstMaterial?.diffuse.contents = UIImage(named: "earth.jpg")
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0.5, 0, -0.5)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}
