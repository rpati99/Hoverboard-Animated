//
//  ViewController.swift
//  HoverBoard Animated
//
//  Created by Rachit Prajapati on 30/03/21.
//

import UIKit
import SceneKit



class ViewController: UIViewController {

    var isOpened = false
    
    
    //MARK: - Data
   
   let players: [Player] = [ Player(firstName: "TOM", lastName: "ASTA", themeColor: UIColor(red: 60/255, green: 117/255, blue: 131/255, alpha: 1.0)), Player(firstName: "CHRIS", lastName: "JOSLIN", themeColor: UIColor(red: 87/255, green: 147/255, blue: 180/255, alpha: 1.0))]
    
    
    
    
    // MARK: - Elements
    
    var scnView: SCNView!
    var baseNode: SCNNode!
    
    private lazy var collectionView: UICollectionView = {
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
    
    private let oneName: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont(name: "Deutschlander", size: 200)
            return label
    }()
    
    private let twoName: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont(name: "Deutschlander", size: 220)
        return label
    }()
    
    private let viewStats: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View stats", for: .normal)
        button.setDimensions(width: 175, height: 50)
        button.layer.cornerRadius = 23
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(showStat), for: .touchUpInside)
        return button
    }()

    
   
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
        configureScene()
        
    }
    
    
    // MARK: - Selectors
    
    @objc func showStat() {
    
        if !isOpened {
           
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveEaseOut]) {
                self.collectionView.transform = self.collectionView.transform.scaledBy(x: 1.0, y: 1.4)
                self.viewStats.setTitle("Close", for: .normal)
                self.viewStats.setTitleColor(.white, for: .normal)
                self.viewStats.backgroundColor = .orange
            }
            
            baseNode.runAction(SCNAction.move(to: SCNVector3(-18, 0, 0), duration: 0.7))
            
            
            for cell in collectionView.visibleCells  {
                let cell = cell as! PlayerCell
                UIView.animate(withDuration: 0.6 ) {
                    cell.playerName.layer.position.y += 100
                    cell.status.layer.position.y += 120
                }
                
                cell.animateStats()
            }
            isOpened = true
        } else if isOpened  {
            
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveEaseOut]) {
                self.collectionView.transform = CGAffineTransform.identity
                self.viewStats.setTitle("View stats", for: .normal)
                self.viewStats.setTitleColor(.orange, for: .normal)
                self.viewStats.backgroundColor = .white

            }
            isOpened = false
            
            for cell in collectionView.visibleCells  {
                let cell = cell as! PlayerCell
                UIView.animate(withDuration: 0.6) {
                    cell.playerName.layer.position.y -= 100
                    cell.status.layer.position.y -= 120
                   
                }
                cell.positionToNormal()
            }
            baseNode.runAction(SCNAction.move(to: SCNVector3(0, 0, 0), duration: 0.7))
        }
        
        
      


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
    
    private func nameAnimation(firstName: String, lastName: String)  {
        oneName.text = firstName
        twoName.text = lastName
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseInOut]) {
            self.oneName.layer.position.x += 300
            self.twoName.layer.position.y -= 300
   
        }


        
    }
    
    private func hoverBoard(angleY: CGFloat) {
        let rotateAction = SCNAction.rotateBy(x: 0.0, y: angleY, z: 0.0, duration: 0.7)
             self.baseNode.runAction(rotateAction)
        let scaleAction = SCNAction.scale(to: 0.95, duration: 0.35)
            self.baseNode.runAction(scaleAction)
        if angleY == -6.27 {
                collectionView.scrollToItem(at: [0,1], at: .left, animated: true)
            
            
            if collectionView.indexPathsForVisibleItems != [[0, 1]] {
                for cell in collectionView.visibleCells {
                    let cell = cell as! PlayerCell
                    cell.animateMeta()
                }
                nameAnimation(firstName: players[1].firstName, lastName: players[1].lastName)
            }

        } else if angleY == 6.27 {
                collectionView.scrollToItem(at: [0,0], at: .right, animated: true)
            
            if collectionView.indexPathsForVisibleItems != [[0, 0]] {
            for cell in collectionView.visibleCells {
                let cell = cell as! PlayerCell
                cell.animateMeta()
            }
            nameAnimation(firstName: players[0].firstName, lastName: players[0].lastName)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            let scaleAction = SCNAction.scale(to: 0.7, duration: 0.35)
                self.baseNode.runAction(scaleAction)
            }
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

}



extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PlayerCell
        cell.player = players[indexPath.row]
        twoName.text = players[indexPath.row].lastName
        oneName.text = players[indexPath.row].firstName
        cell.animateMeta()
        nameAnimation(firstName: players[indexPath.row].firstName, lastName: players[indexPath.row].lastName)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}


