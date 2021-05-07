//
//  LaunchMissle.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import UIKit
import SceneKit
import ARKit

class LaunchMissleViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView = ARSCNView(frame: screenBounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let missleScene = SCNScene(named: "Helper/missile-1.scn")
        
        let missile = Missile(scene: missleScene!)
        missile.name = "Missile"
        missile.position = SCNVector3(0,0,-4)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(missile)
        
        sceneView.scene = scene
        
        registerGestureRecognizers()
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        guard let missileNode = self.sceneView.scene.rootNode.childNode(withName: "Missile", recursively: true)
            else {
                fatalError("Missile not found")
        }
        
        // get the smoke node
        guard let smokeNode = missileNode.childNode(withName: "smokeNode", recursively: true) else {
            fatalError("no smoke node found")
        }
        
        smokeNode.removeAllParticleSystems()
        
        let fire = SCNParticleSystem(named: "fire.scnp", inDirectory: nil)
        
        smokeNode.addParticleSystem(fire!)
        
        missileNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        missileNode.physicsBody?.isAffectedByGravity = false
        missileNode.physicsBody?.damping = 0.0
        
        missileNode.physicsBody?.applyForce(SCNVector3(0,100,0), asImpulse: false)
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



