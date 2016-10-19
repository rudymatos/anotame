//
//  PlayerTypeCVC.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/15/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class PlayerTypeCVC: UICollectionViewCell, HighlightStateChanger {
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    internal var state = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureView(){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.3
    }
    
    func changeHighlightState(){
        UIView.animate(withDuration: 0.3) {
            self.layer.backgroundColor = self.state ?   UIColor.white.cgColor : ColorHelper.mainColor.cgColor
            self.typeLabel.textColor = self.state ? ColorHelper.mainColor : UIColor.white
        }
        state = !state
    }
    
}
