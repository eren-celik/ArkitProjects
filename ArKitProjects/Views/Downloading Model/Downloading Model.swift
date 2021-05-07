//
//  Downloading Model.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import UIKit
import SceneKit
import ARKit

class DownloadingModelViewController: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView(frame: screenBounds)
    
    private var hud :MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        registerGestureRecognizers()
        
        downloadModels()
        
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentDirectory = documentDirectories.first {
            
            let fileURL = documentDirectory.appendingPathComponent("003a6-av-1753-5kt.usdz")
            
            do {
            
                
                let scene = try SCNScene(url: fileURL, options: nil)
                let node = scene.rootNode.childNode(withName: "_003a6_av_1753_5kt", recursively: true)!
                
                node.position = SCNVector3(0,0,-1)
                node.scale = SCNVector3(0.006, 0.006, 0.006)
                
                self.sceneView.scene.rootNode.addChildNode(node)
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
    private func downloadModels() {
        
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud.label.text = "Downloading Resources..."
        
        let url = URL(string: "https://aviled.com.tr/apps/3dmodels/003a6-av-1753-5kt.usdz")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = data {
                
                let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                
                if let documentDirectory = documentDirectories.first {
                    
                    let fileURL = documentDirectory.appendingPathComponent("003a6-av-1753-5kt.usdz")
                    let dataNS :NSData? = data as NSData
                    
                    try! dataNS?.write(to: fileURL, options: .atomic)
                    
                    DispatchQueue.main.async {
                        self.hud.hide(animated: true, afterDelay: 1.0)
                    }
                    
                    
                    print(fileURL.absoluteString)
                    print("SAVED!")
                    
                }
                
                
            }
            
        }.resume()
        
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

