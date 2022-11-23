//
//  ViewController.swift
//  Magical NewsPaper
//
//  Created by Sourav Singh Rawat on 23/11/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "News", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 1
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
  
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        let planeNode = createPlane(withImageAnchor: imageAnchor)
        
        return planeNode
    }
    
    func createPlane(withImageAnchor imageAnchor: ARImageAnchor) -> SCNNode{
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0.8)
        
        plane.materials = [planeMaterial]
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        
        return planeNode
    }
}
