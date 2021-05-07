//
//  ArkitCoreMLViewController.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import UIKit
import Vision
import ARKit
import SceneKit

class ArkitCoreMLViewController: UIViewController ,ARSCNViewDelegate{
    
    
    
    let resnetModel: Resnet50 = {
        do {
            let config = MLModelConfiguration()
            return try Resnet50(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create SleepCalculator")
        }
    }()
    
    private var hitTestResult :ARHitTestResult!
    private var visionRequests = [VNRequest]()
    
    var sceneView = ARSCNView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        registerGestureRecognizers()
        
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer :UIGestureRecognizer) {
        
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = self.sceneView.center
        
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        
        let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
        
        if hitTestResults.isEmpty {
            return
        }
        
        guard let hitTestResult = hitTestResults.first else {
            return
        }
        
        self.hitTestResult = hitTestResult
        let pixelBuffer = currentFrame.capturedImage
        
        performVisionRequest(pixelBuffer: pixelBuffer)
    }
    
    private func displayPredictions(text :String) {
        
        let node = createText(text: text)
        
        node.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x, self.hitTestResult.worldTransform.columns.3.y, self.hitTestResult.worldTransform.columns.3.z)
        
        self.sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    private func createText(text: String) -> SCNNode {
        
        let parentNode = SCNNode()
        
        let sphere = SCNSphere(radius: 0.01)
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIColor.orange
        sphere.firstMaterial = sphereMaterial
        let sphereNode = SCNNode(geometry: sphere)
        
        let textGeometry = SCNText(string: text, extrusionDepth: 0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.orange
        textGeometry.firstMaterial?.specular.contents = UIColor.white
        textGeometry.firstMaterial?.isDoubleSided = true
        
        let font = UIFont(name: "Futura", size: 0.15)
        textGeometry.font = font
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        
        parentNode.addChildNode(sphereNode)
        parentNode.addChildNode(textNode)
        return parentNode
    }
    
    private func performVisionRequest(pixelBuffer :CVPixelBuffer) {
        
        let visionModel = try! VNCoreMLModel(for: self.resnetModel.model)
        
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            
            if error != nil {
                return
            }
            
            guard let observations = request.results else {
                return
            }
            
            let observation = observations.first as! VNClassificationObservation
            
            print("Name \(observation.identifier) and confidence is \(observation.confidence)")
            
            DispatchQueue.main.async {
                self.displayPredictions(text: observation.identifier)
            }
            
        }
        
        request.imageCropAndScaleOption = .centerCrop
        self.visionRequests = [request]
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: [:])
        
        DispatchQueue.global().async {
            try! imageRequestHandler.perform(self.visionRequests)
        }
        
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
