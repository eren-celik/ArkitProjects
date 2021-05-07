//
//  ImageDetection.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import Foundation
import UIKit
import SceneKit
import ARKit
let screenBounds = UIScreen.main.bounds
class ImageDetectionViewController: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView(frame: screenBounds)
    private var hud :MBProgressHUD!
    
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
        
        if let imageAnchor = anchor as? ARImageAnchor {
            if let name = imageAnchor.referenceImage.name {
                
                DispatchQueue.main.async {
                    
                    self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    self.hud.label.text = name
                    
                    self.hud.hide(animated: true, afterDelay: 2.0)
                }
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        // Create a session configuration
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        
        /*
        let blackBerryRefImage = ARReferenceImage((UIImage(named: "BlackBerry.JPG")?.cgImage!)!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.28)
        
         let javaRefImage = ARReferenceImage((UIImage(named: "Java.JPG")?.cgImage!)!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.16)
        
        
        configuration.detectionImages = Set([blackBerryRefImage,javaRefImage])
 */
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
  
}
