//
//  LeaguePlayerTVC.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/13/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

protocol PlayerActionDelegate{
    func editPlayer(cell: UITableViewCell)
    func addPlayerToArrivingList(cell: UITableViewCell)
}


class LeaguePlayerTVC: UITableViewCell {
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerInfo: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var buttonCheck: UIButton!
    var delegate : PlayerActionDelegate?
    var state = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    
    func configureView(){
        layoutIfNeeded()
        playerImage.layer.cornerRadius = playerImage.frame.size.height / 2
        playerImage.layer.masksToBounds = true
        playerImage.layer.borderWidth = 0
    }
    
    @IBAction func checkButtonDidTouch(_ sender: UIButton) {
        let currentImage = state ?  UIImage(named: "player_search_unchecked") : UIImage(named: "player_search_checked")
        buttonCheck.setImage(currentImage, for: .normal)
        state = !state
        delegate?.addPlayerToArrivingList(cell: self)
    }
    
    @IBAction func editPlayerButtonDidTouch(_ sender: UIButton) {
        delegate?.editPlayer(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
