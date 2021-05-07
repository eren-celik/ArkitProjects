//
//  MeasuringApp.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var spheres = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        addCrossSign()
        registerGestureRecognizers()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer :UIGestureRecognizer) {
        
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = self.sceneView.center
        
        let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
        
        if !hitTestResults.isEmpty {
            
            guard let hitTestResult = hitTestResults.first else {
                return
            }
            
            let sphere = SCNSphere(radius: 0.005)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            
            sphere.firstMaterial = material
            
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z)
            
            self.sceneView.scene.rootNode.addChildNode(sphereNode)
            self.spheres.append(sphereNode)
            
            if self.spheres.count == 2 {
                
                let firstPoint = self.spheres.first!
                let secondPoint = self.spheres.last!
                
                let position = SCNVector3Make(secondPoint.position.x - firstPoint.position.x, secondPoint.position.y - firstPoint.position.y, secondPoint.position.z - firstPoint.position.z)
                
                let result = sqrt(position.x*position.x + position.y*position.y + position.z*position.z)
                
                let centerPoint = SCNVector3((firstPoint.position.x+secondPoint.position.x)/2,(firstPoint.position.y+secondPoint.position.y),(firstPoint.position.z+secondPoint.position.z))
                
                display(distance: result, position: centerPoint)
                
            }
        }
        
    }
    
    private func display(distance: Float,position :SCNVector3) {
        
        let textGeo = SCNText(string: "\(distance) m", extrusionDepth: 1.0)
        textGeo.firstMaterial?.diffuse.contents = UIColor.black
        
        let textNode = SCNNode(geometry: textGeo)
        textNode.position = position
        textNode.rotation = SCNVector4(1,0,0,Double.pi/(-2))
        textNode.scale = SCNVector3(0.002,0.002,0.002)
        
        self.sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    private func addCrossSign() {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 33))
        label.text = "+"
        label.textAlignment = .center
        label.center = self.sceneView.center
        
        self.sceneView.addSubview(label)
        
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
