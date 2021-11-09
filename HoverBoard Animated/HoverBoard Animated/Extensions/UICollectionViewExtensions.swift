//
//  UICollectionViewExtensions.swift
//  HoverBoard Animated
//
//  Created by Rachit Prajapati on 09/11/21.
//

import Foundation
import UIKit

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



