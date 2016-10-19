//
//  PlayerSearchVC.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/13/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class PlayerSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, PlayerActionDelegate{
    
    
    @IBOutlet weak var playerListTV: UITableView!
    var filteredPlayerList : [Player]?
    var playerToEdit : Player?
    var currentActiveBoard : Board? {
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        filteredPlayerList = currentActiveBoard?.league?.players?.allObjects as? [Player]
        navigationController?.navigationBar.tintColor = UIColor.white
        let backImage = UIImage(named: "navBack")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createNewPlayerVC = segue.destination as! PlayerInfoVC
        if segue.identifier == "createNewPlayerSegue"{
            createNewPlayerVC.currentLeague = currentActiveBoard?.league
        }else if segue.identifier == "editPlayerSegue"{
            createNewPlayerVC.currentPlayer = playerToEdit
            createNewPlayerVC.editMode = true
        }
    }
    
    @IBAction func goBackFromCreatingNewPlayer(segue: UIStoryboardSegue){
        filteredPlayerList = currentActiveBoard?.league?.players?.allObjects as? [Player]
        playerListTV.reloadData()
    }
    
    
    //MARK: -ADDING BUTTONS TO NAVBAR
    func activateAddPlayersButtonOnNavBar(){
        if let count = self.navigationItem.rightBarButtonItems?.count ,  count <= 1{
            if let applyImage = UIImage(named: "player_search_apply"){
                let applyButton = UIBarButtonItem(image: applyImage, style: .plain, target: self, action: #selector(PlayerSearchVC.addPlayersToList))
                self.navigationItem.rightBarButtonItems?.append(applyButton)
            }
        }
    }
    
    func addPlayersToList(){
        print("adding players")
    }
    
    //MARK: -UISearchBardDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let players = currentActiveBoard?.league?.players?.allObjects as? [Player]
        if searchText.isEmpty{
            filteredPlayerList = players
        }else{
            filteredPlayerList = players?.filter {($0.name?.uppercased().contains(searchText.uppercased()))!}
        }
        playerListTV.reloadData()
    }
    
    //MARK: -PlayerActionDelegate
    func addPlayerToArrivingList(cell: UITableViewCell) {
        if let selectedCellIndex = playerListTV.indexPath(for: cell){
            print("working with player : \(filteredPlayerList?[selectedCellIndex.row].name)")
            activateAddPlayersButtonOnNavBar()
        }
    }
    
    func editPlayer(cell: UITableViewCell) {
        if let selectedCellIndex = playerListTV.indexPath(for: cell), let player = filteredPlayerList?[selectedCellIndex.row]{
            playerToEdit = player
            performSegue(withIdentifier: "editPlayerSegue", sender: nil)
        }
    }
    
    //MARK: -UITableView Delegate/Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlayerList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! LeaguePlayerTVC
        cell.delegate = self
        if let playerData = filteredPlayerList?[indexPath.row], let playerType = playerData.player_type , let playerTypeEnum = PlayerTypeEnum(rawValue: playerType.name!){
            cell.playerName.text = playerData.name
            let playerPositionString = PlayerPositionEnum.getPlayerPositionsString(positions: playerData.positions?.allObjects as! [PlayerPosition])
            cell.playerInfo.text = "#\(playerData.number) / \(playerTypeEnum.getSpanishValue()) / \(playerPositionString)"
            if let playerPhoto = playerData.photo as? Data{
                cell.playerImage.image = UIImage(data: playerPhoto)
            }
        }
        return cell
    }
    
    
}
