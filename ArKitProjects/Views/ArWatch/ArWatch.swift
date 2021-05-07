//
//  ArWatch.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import UIKit
import SceneKit
import ARKit

class ArWatchViewController: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView(frame: screenBounds)
    
    let availableColors = [UIColor.red, UIColor.purple, UIColor.orange, UIColor.blue]
    
    private var offsetX: CGFloat = 20
    
    private var watchNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        
        sceneView.autoenablesDefaultLighting = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addColorSwatches()
    }
    
    private func addColorSwatches() {
        
        for availableColor in self.availableColors {
            
            let swatchView = ColorSwatch(color: availableColor) { color in
                
                guard let bandNode = self.watchNode.childNode(withName: "band", recursively: true) else {
                    return
                }
                
                bandNode.geometry?.firstMaterial?.diffuse.contents = color
                
            }
            
            self.view.addSubview(swatchView)
            // configure constraints
            configureConstraints(for: swatchView)
            
        }
        
    }
    
    private func configureConstraints(for swatchView: UIView) {
        
        swatchView.translatesAutoresizingMaskIntoConstraints = false
        
        swatchView.widthAnchor.constraint(equalToConstant: swatchView.frame.size.width).isActive = true
        swatchView.heightAnchor.constraint(equalToConstant: swatchView.frame.size.height).isActive = true
        
        swatchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        swatchView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offsetX).isActive = true
        
        offsetX += self.view.frame.width / 4
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let anchor = anchor as? ARImageAnchor {
            
            let refImage = anchor.referenceImage
            addWatch(to: node, referenceImage: refImage)
            
        }
        
    }
    
    private func addWatch(to node: SCNNode, referenceImage: ARReferenceImage) {
       
        DispatchQueue.global().async {
            
            let watchScene = SCNScene(named: "watch-model.dae")!
            self.watchNode = watchScene.rootNode.childNode(withName: "watch", recursively: true)!
            
            let cylinder = SCNCylinder(radius: referenceImage.physicalSize.width/1.8, height: referenceImage.physicalSize.height)
            cylinder.firstMaterial?.diffuse.contents = UIColor.purple
            cylinder.firstMaterial?.colorBufferWriteMask = []
            
            let cylinderNode = SCNNode(geometry: cylinder)
            cylinderNode.eulerAngles.x = .pi/2
            cylinderNode.renderingOrder = -1
            
            let centerY = (self.watchNode.boundingBox.max.y + self.watchNode.boundingBox.min.y) / 2
            
            cylinderNode.position.y = centerY + 0.008
            
            
            node.addChildNode(self.watchNode)
            node.addChildNode(cylinderNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("No reference images found...")
        }
        
        configuration.trackingImages = referenceImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
 
}

