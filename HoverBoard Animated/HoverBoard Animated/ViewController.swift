//
//  ViewController.swift
//  HoverBoard Animated
//
//  Created by Rachit Prajapati on 30/03/21.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

   private var isOpened = false
    
    //MARK: - Data
   
   let players: [Player] = [
    Player(firstName: "TOM",
           lastName: "ASTA",
           themeColor: UIColor(red: 60/255, green: 117/255, blue: 131/255, alpha: 1.0)),
    Player(firstName: "CHRIS",
           lastName: "JOSLIN",
           themeColor: UIColor(red: 87/255, green: 147/255, blue: 180/255, alpha: 1.0))
   ]
    
    
    // MARK: - Elements
    
    var scnView: SCNView!
    var baseNode: SCNNode!
    let animationService: AnimationService = AnimationService()
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.showsHorizontalScrollIndicator = false
        cv.register(PlayerCell.self, forCellWithReuseIdentifier: "cellid")
        cv.setCollectionViewLayout(layout, animated: false)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let oneName: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont(name: "Deutschlander", size: 200)
            return label
    }()
    
    let twoName: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont(name: "Deutschlander", size: 220)
        return label
    }()
    
    let viewStats: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View stats", for: .normal)
        button.setDimensions(width: 175, height: 50)
        button.layer.cornerRadius = 23
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(showStats), for: .touchUpInside)
        return button
    }()

    
   
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureScene()
        
    }
    
    
    // MARK: - Selectors
    
    @objc private func showStats() {
        animationService.selectorAnimation(status: &isOpened, collectionView: collectionView, viewStats: viewStats, baseNode: baseNode)
    }
    
    @objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            print("DBG: Left")
            hoverBoard(angleY: -6.27)
        case .right:
            print("DBG: right")
            hoverBoard(angleY: 6.27)
        default:
            break
        }
    }
    
    
    // MARK: - API
    
  func nameAnimation(firstName: String, lastName: String)  {
        oneName.text = firstName
        twoName.text = lastName
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseInOut]) { [self] in
            oneName.layer.position.x += 300
            twoName.layer.position.y -= 300
   
        }
    }
    
    private func hoverBoard(angleY: CGFloat) {
        AnimationService().hoverBoard(angleY: angleY, baseNode: baseNode, collectionView: collectionView, players: players) { value in
            switch value {
            case -6.27:
                nameAnimation(firstName: players[1].firstName, lastName: players[1].lastName)
            case 6.27:
                nameAnimation(firstName: players[0].firstName, lastName: players[0].lastName)
            default:
                debugPrint("")
            }
        }
    }


    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor =  UIColor(red: 35/255, green: 35/255, blue: 32/255, alpha: 1.0)
        view.addSubview(oneName)
        oneName.anchor(top: view.topAnchor, left: view.leftAnchor)
        view.addSubview(twoName)
        twoName.anchor(top: oneName.bottomAnchor, right: view.rightAnchor, paddingTop: -70, paddingRight: -10 )
        view.addSubview(collectionView)
        collectionView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        collectionView.heightAnchor.constraint(equalToConstant:  view.frame.height - (view.frame.height / 2.6)).isActive = true
        scnView = SCNView()
        scnView.backgroundColor = .clear
        view.addSubview(scnView)
        scnView.centerX(inView: view)
        scnView.centerY(inView: view)
        scnView.setDimensions(width: view.frame.width, height: view.frame.height - 100)
        view.addSubview(viewStats)
        viewStats.centerX(inView: view)
        viewStats.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
    }

    private func configureScene() {
            let scene = SCNScene(named: "board.dae")
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light?.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            lightNode.light?.shadowMode = .deferred
            lightNode.light?.type = .omni
            lightNode.position = SCNVector3(x: 0, y: 70, z: 35)
            lightNode.castsShadow = true
            scene?.rootNode.addChildNode(lightNode)
        
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light?.type = .ambient
            ambientLightNode.light?.color = UIColor.white
            scene?.rootNode.addChildNode(ambientLightNode)
        
            baseNode = scene?.rootNode.childNode(withName: "baseNode", recursively: false)
            scnView.scene?.rootNode.addChildNode(baseNode)
            scnView.scene = scene
        
            baseNode.scale = SCNVector3(0.7, 0.7, 0.7)
            scnView.defaultCameraController.maximumVerticalAngle = 0
            scnView.defaultCameraController.minimumVerticalAngle = 90
           
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        scnView.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        scnView.addGestureRecognizer(swipeLeft)

    }

}



