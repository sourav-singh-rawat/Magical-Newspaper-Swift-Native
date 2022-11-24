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
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let scene = createVideoScene()
            
            let planeNode = createPlane(
                withImageAnchor: imageAnchor,
                withContents: scene
            )
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    func createPlane(withImageAnchor imageAnchor: ARImageAnchor,withContents contents:Any?) -> SCNNode{
        let plane = SCNPlane(
            width: imageAnchor.referenceImage.physicalSize.width,
            height: imageAnchor.referenceImage.physicalSize.height
        )
        
        plane.firstMaterial?.diffuse.contents = contents
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        
        return planeNode
    }
    
    func createVideoScene() -> SKScene{
        let video2DNode = SKVideoNode(fileNamed: "Harry-Potter.mp4")
        video2DNode.play()
        
        let scene = SKScene(size: CGSize(width: 720, height: 420))
        
        //Position to center and cover whole area
        video2DNode.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)

        //Flip
        video2DNode.yScale = -1.0
        
        scene.addChild(video2DNode)
    
        return scene
    }
}
