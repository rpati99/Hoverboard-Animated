//
//  AnimationService.swift
//  HoverBoard Animated
//
//  Created by Rachit Prajapati on 09/11/21.
//

import Foundation
import UIKit
import SceneKit

struct AnimationService {
    
    func selectorAnimation(status: inout Bool, collectionView: UICollectionView, viewStats: UIButton, baseNode: SCNNode) {
        if !status {
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveEaseOut]) {
                collectionView.transform = collectionView.transform.scaledBy(x: 1.0, y: 1.4)
                viewStats.setTitle("Close", for: .normal)
                viewStats.setTitleColor(.white, for: .normal)
                viewStats.backgroundColor = .orange
            }
            
            baseNode.runAction(SCNAction.move(to: SCNVector3(-18, 0, 0), duration: 0.7))
            
            for cell in collectionView.visibleCells  {
                let cell = cell as! PlayerCell
                cell.animateStats()
            }
            
            status = true
        } else if status  {
            
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveEaseOut]) {
                collectionView.transform = CGAffineTransform.identity
                viewStats.setTitle("View stats", for: .normal)
                viewStats.setTitleColor(.orange, for: .normal)
                viewStats.backgroundColor = .white
            }
            
            status = false
            
            for cell in collectionView.visibleCells  {
                let cell = cell as! PlayerCell
                cell.positionToNormal()
            }
            
            baseNode.runAction(SCNAction.move(to: SCNVector3(0, 0, 0), duration: 0.7))
        }
    }
    
    
    
    func hoverBoard(angleY: CGFloat, baseNode: SCNNode, collectionView: UICollectionView, players: [Player], completion: (CGFloat) -> Void) {
        let rotateAction = SCNAction.rotateBy(x: 0.0, y: angleY, z: 0.0, duration: 0.7)
             baseNode.runAction(rotateAction)
        let scaleAction = SCNAction.scale(to: 0.95, duration: 0.35)
            baseNode.runAction(scaleAction)
        if angleY == -6.27 {
                collectionView.scrollToItem(at: [0,1], at: .left, animated: true)
            
            if collectionView.indexPathsForVisibleItems != [[0, 1]] {
                for cell in collectionView.visibleCells {
                    let cell = cell as! PlayerCell
                    cell.animateMeta()
                }
                
            completion(angleY)
            
            }

        } else if angleY == 6.27 {
                collectionView.scrollToItem(at: [0,0], at: .right, animated: true)
            
            if collectionView.indexPathsForVisibleItems != [[0, 0]] {
            for cell in collectionView.visibleCells {
                let cell = cell as! PlayerCell
                cell.animateMeta()
            }
                
            completion(angleY)
          
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            let scaleAction = SCNAction.scale(to: 0.7, duration: 0.35)
                baseNode.runAction(scaleAction)
            }
    }
}
