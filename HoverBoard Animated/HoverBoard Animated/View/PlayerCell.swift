//
//  PlayerInfoCell.swift
//  FlipDaBoard
//
//  Created by Rachit Prajapati on 29/03/21.
// 60 117 131

import UIKit

class PlayerCell : UICollectionViewCell {
    
    var player: Player? {
        didSet {
            guard let player = player else { return }
            playerName.text = "\(player.firstName)   \(player.lastName)"
            backgroundColor = player.themeColor
        }
    }

    private let status: UILabel = {
        let label = UILabel()
        label.text = "Finalist"
        label.font = UIFont(name: "Deutschlander", size: 40)
        label.textColor = .black
        return label
    }()
    
    
    private let playerName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Deutschlander", size: 55)
        label.textColor = .white
        return label
    }()
    
    
    private let age: UILabel = {
        let label = UILabel()
        label.text = "Age: 21"
        label.font = UIFont(name: "Deutschlander", size: 65)
        label.textColor = .white
        return label
    }()
    
    private let country: UILabel = {
        let label = UILabel()
        label.text = "Country: USA"
        label.font = UIFont(name: "Deutschlander", size: 65)
        label.textColor = .white
        return label
    }()
    
    
    private let boarder: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "skateDude")
        iv.contentMode = .scaleToFill
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    private  let cancel: UIButton = {
        let iv = UIButton(type: .system)
        iv.setImage(UIImage(named: "cancel"), for: .normal)
        iv.setDimensions(width: 55, height: 40)
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateStats() {
        UIView.animate(withDuration: 0.6 ) { [self] in 
            playerName.layer.position.y += 100
            status.layer.position.y += 120
        }
        
        UIView.animate(withDuration: 1.0) { [self] in 
            age.alpha = 1
            country.alpha = 1
            boarder.alpha = 0.5
            cancel.alpha = 1
            age.layer.position.x += 60
            country.layer.position.x += 60
            boarder.layer.position.y -= 100
        }
    }
    
    func positionToNormal() {
        
        UIView.animate(withDuration: 0.6) { [self] in
            playerName.layer.position.y -= 100
            status.layer.position.y -= 120
           
        }
        UIView.animate(withDuration: 1.0) { [self] in
            age.alpha = 0
            country.alpha = 0
            boarder.alpha = 0
            cancel.alpha = 0
            age.layer.position.x -= 60
            country.layer.position.x -= 60
            boarder.layer.position.y += 100
        }
    }
    
    
    func accelerate() {
        UIView.animate(withDuration: 0.25) { [self] in
            status.layer.position.x += 120
            playerName.layer.position.x += 120
        }
    }
    
    
   func animateMeta() {
        status.layer.position.y += 320
        playerName.layer.position.y += 320
        UIView.animate(withDuration: 2.0) { [self] in
            status.alpha = 1
            playerName.alpha = 1
            status.layer.position.y -= 320
            playerName.layer.position.y -= 320

        }
    }
    
    private func setupUI() {
        age.alpha = 0
        country.alpha = 0
        status.alpha = 0
        playerName.alpha = 0
        cancel.alpha = 0
        boarder.alpha = 0

        contentView.addSubview(status)
        status.centerX(inView: contentView)
        status.anchor(bottom: contentView.bottomAnchor, paddingBottom: 125)
        
        contentView.addSubview(playerName)
        playerName.centerX(inView: contentView)
        playerName.anchor(top: status.bottomAnchor, paddingTop: -12)
        
        contentView.addSubview(age)
        age.centerX(inView: contentView)
        age.anchor(top: contentView.topAnchor, paddingTop: 60)
        
        contentView.addSubview(country)
        country.centerX(inView: contentView)
        country.anchor(top: age.bottomAnchor, paddingTop: 20)
        
        contentView.addSubview(boarder)
        boarder.centerX(inView: contentView)
        boarder.anchor(bottom: contentView.bottomAnchor, paddingBottom: 2)
        boarder.setDimensions(width: 300, height: 200)
        
    
    }
    
    
    
}

