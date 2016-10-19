//
//  PlayerPositionCVC.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/15/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class PlayerPositionCVC: UICollectionViewCell, HighlightStateChanger {
    
    @IBOutlet weak var position: UILabel!
    internal var state = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureView(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.3
    }
    
    func changeHighlightState(){
        UIView.animate(withDuration: 0.3) {
            self.layer.backgroundColor = self.state ?   UIColor.white.cgColor : ColorHelper.mainColor.cgColor
            self.position.textColor = self.state ?   UIColor.black : UIColor.white
        }
        state = !state
    }
    
    
    
}
