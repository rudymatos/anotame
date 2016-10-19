//
//  NewPlayerVC.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/15/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class PlayerInfoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource , UITextFieldDelegate{
    
    
    private let cdHelper = CoreDataHelper.staticInstance
    private let alertHelper = AlertControllerHelper.staticInstance
    
    private var playerPositionList: [PlayerPosition]! = nil
    private var playerTypeList: [PlayerType]! = nil
    private var previousElementSelected : IndexPath?
    
    var editMode = false
    var currentPlayer : Player?
    
    var currentLeague: League?
    
    @IBOutlet weak var cameraViewToHide: UIView!
    @IBOutlet weak var selectedPic: UIImageView!
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var playerNick: UITextField!
    @IBOutlet weak var playerPositionsCV: UICollectionView!
    @IBOutlet weak var playerTypeCV: UICollectionView!
    @IBOutlet weak var playerNumber: UITextField!
    @IBOutlet weak var deletePlayerButton: UIButton!
    
    //Layout Properties
    @IBOutlet weak var playerTypeTopLayout: NSLayoutConstraint!
    @IBOutlet weak var functionButtonsLayout: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
        
        //View configuration
        let backImage = UIImage(named: "navBack")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage  = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        configureRoundedViews(view: selectedPic)
        
        
        //Getting all the data from DB
        playerPositionList = cdHelper.getAllPositions()
        playerTypeList = cdHelper.getAllPlayerTypes()
        
        //Setting multiselection for player positions
        playerPositionsCV.allowsMultipleSelection = true
        
        
        //Edit mode configuration
        
        deletePlayerButton.isHidden = true
        
        if editMode{
            if let currentPlayer = currentPlayer{
                
                currentLeague = currentPlayer.league
                
                if let playerType = currentPlayer.player_type, let playerTypeIndex = playerTypeList.index(of: playerType){
                    let playerTypeIndexPath = IndexPath(row: playerTypeIndex, section: 0)
                    playerTypeCV.selectItem(at: playerTypeIndexPath, animated: true, scrollPosition: .centeredVertically)
                    handleCVSelection(collectionView: playerTypeCV, indexPath: playerTypeIndexPath)
                }
                if let name = currentPlayer.name {
                    playerName.text = name
                }
                
                if let nick = currentPlayer.nick{
                    playerNick.text = nick
                }
                
                playerNumber.text =  "\(currentPlayer.number)"
                
                if let picture = currentPlayer.photo{
                    cameraViewToHide.isHidden = true
                    selectedPic.isHidden = false
                    selectedPic.image = UIImage(data: picture as Data)
                }
                
                if let currentPlayerPositions = currentPlayer.positions{
                    for position in currentPlayerPositions{
                        if let positionIndex = playerPositionList.index(of: position as! PlayerPosition) {
                            let positionIndexPath = IndexPath(row: positionIndex, section: 0)
                            playerPositionsCV.selectItem(at: positionIndexPath, animated: true, scrollPosition: .top)
                            handleCVSelection(collectionView: playerPositionsCV, indexPath: positionIndexPath)
                        }
                    }
                }
                deletePlayerButton.isHidden = false
            }
            
        }else{
            playerTypeTopLayout.constant = 30
            functionButtonsLayout.constant = -30
            currentPlayer = cdHelper.createObject(entityName: Player.entityName) as? Player
        }
    }
    
    func configureRoundedViews(view: UIView){
        view.layoutIfNeeded()
        view.layer.cornerRadius = view.frame.size.height / 2
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.masksToBounds = true
    }
    
    //MARK: -IMAGEPICKER IMPLEMENTATION
    @IBAction func addPlayerPicture(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "Agregar foto a Jugador", message: "Seleccione si desea seleccionar una foto de la biblioteca o tomar una foto", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camara", style: .default) { (action) in
            self.presentLibraryOrCamera(playerPhotoType: .Camera)
        }
        let library = UIAlertAction(title: "Biblioteca", style: .default) { (action) in
            self.presentLibraryOrCamera(playerPhotoType: .Library)
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        actionSheet.addAction(camera)
        actionSheet.addAction(library)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraViewToHide.isHidden = true
        selectedPic.isHidden = false
        selectedPic.image = info[UIImagePickerControllerEditedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    enum AddPlayerPhoto{
        case Camera
        case Library
    }
    
    func presentLibraryOrCamera(playerPhotoType : AddPlayerPhoto){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        switch playerPhotoType {
        case .Camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
            }
            
        case .Library:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagePicker.sourceType = .photoLibrary
            }
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: -PLAYER IMPLEMENATATION
    @IBAction func savePlayer(_ sender: UITapGestureRecognizer) {
        
        var imageData : NSData?
        
        //VALIDATE ALL DATA FIRST
        if let selectedImage = selectedPic.image{
            imageData = UIImageJPEGRepresentation(selectedImage, 1) as NSData?
        }
        
        guard let currentPlayerName =  playerName.text else{
            present(alertHelper.createErrorMessageDialog(title: "Data Invalida", errorMessage: "Nombre de jugador no encontrado"), animated: true, completion: nil)
            return
        }
        
        if playerPositionsCV.indexPathsForSelectedItems?.count == 0{
            present(alertHelper.createErrorMessageDialog(title: "Data Invalida", errorMessage: "Posiciones de jugador no encontradas"), animated: true, completion: nil)
            return
        }
        
        var currentPlayerPositions = [PlayerPosition]()
        if let currentPlayerPositionsIndexes = playerPositionsCV.indexPathsForSelectedItems{
            for currentPlayerPositionIndex in currentPlayerPositionsIndexes{
                if let playerPosition = playerPositionList?[currentPlayerPositionIndex.item]{
                    currentPlayerPositions.append(playerPosition)
                }
            }
        }
        
        guard let playerTypeSelectedIndex = playerTypeCV.indexPathsForSelectedItems?.first else{
            present(alertHelper.createErrorMessageDialog(title: "Data Invalida", errorMessage: "Tipo de jugador no encontrado"), animated: true, completion: nil)
            return
        }
        
        let currentPlayerType = playerTypeList?[playerTypeSelectedIndex.item]
        
        guard let currentPlayerNumber = playerNumber.text else{
            present(alertHelper.createErrorMessageDialog(title: "Data Invalida", errorMessage: "Numero de jugador no encontrado"), animated: true, completion: nil)
            return
        }
        
        if !editMode {
            if cdHelper.doesPlayerAlreadyExist(playerName: currentPlayerName, playerNumber: Int(currentPlayerNumber)!, leagueName: (currentLeague?.name)!){
                present(alertHelper.createErrorMessageDialog(title: "Data Invalid", errorMessage: "Ya existe un jugador con ese nombre y ese numero en la liga"), animated: true, completion: nil)
                return
            }
        }
        
        if let currentPlayer = currentPlayer{
            currentPlayer.name = currentPlayerName
            currentPlayer.nick = playerNick.text
            currentPlayer.league = currentLeague
            currentPlayer.number = Int16(Int(currentPlayerNumber)!)
            currentPlayer.photo = imageData
            currentPlayer.player_type = currentPlayerType
            currentPlayer.positions = NSSet(array : currentPlayerPositions)
            cdHelper.saveContext()
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "goBackToPlayerListSegue", sender: nil)
        }
        
    }
    
    @IBAction func deletePlayer(_ sender: UIButton) {
        if let playerName = currentPlayer?.name {
            present(alertHelper.createDeleteDialog(title: "Eliminar Jugador", message: "El siguiente jugandor \(playerName) sera eliminado. Desea continuar?", deleteButtonTitle: "Estoy seguro!") { (action) in
                self.cdHelper.deletePlayer(player: self.currentPlayer!)
                self.performSegue(withIdentifier: "goBackToPlayerListSegue", sender: nil)
            }, animated: true, completion: nil)
        }
    }
    //MARK: COLLECTION VIEW IMPLEMENTATION
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return playerPositionList?.count ?? 0
        }else{
            return playerTypeList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerPositionCell", for: indexPath) as! PlayerPositionCVC
            if let currentPosition = playerPositionList?[indexPath.item]{
                cell.position.text = PlayerPositionEnum(rawValue: currentPosition.name!)?.getShortPositionName()
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerTypeCell", for: indexPath) as! PlayerTypeCVC
            if let currentPlayerType = playerTypeList?[indexPath.item]{
                let playerTypeEnum = PlayerTypeEnum(rawValue: currentPlayerType.name!)
                cell.typeLabel.text = playerTypeEnum?.getSpanishValue()
                if let imageName = playerTypeEnum?.rawValue.lowercased(){
                    cell.typeImage.image =  UIImage(named: imageName)
                }
            }
            return cell
        }
    }
    
    func handleCVSelection(collectionView : UICollectionView, indexPath : IndexPath){
        collectionView.layoutIfNeeded()
        if collectionView.tag == 1{
            let cell = collectionView.cellForItem(at: indexPath) as! HighlightStateChanger
            cell.changeHighlightState()
        }else{
            if let previousElementSelected = previousElementSelected{
                let cellToDeselect = collectionView.cellForItem(at: previousElementSelected) as! HighlightStateChanger
                cellToDeselect.changeHighlightState()
                self.previousElementSelected = nil
            }
            
            if let selectedIndex = collectionView.indexPathsForSelectedItems?.first{
                let cell = collectionView.cellForItem(at: selectedIndex) as! HighlightStateChanger
                cell.changeHighlightState()
                self.previousElementSelected = selectedIndex
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleCVSelection(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        handleCVSelection(collectionView: collectionView, indexPath: indexPath)
    }
    
    
    //MARK: -TEXTFIELD DELEGATE IMPLEMENTATION
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            moveView(up: true, distance: 50)
        }else if textField.tag == 2{
            moveView(up: true, distance: 80)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField.tag == 1{
            moveView(up: false, distance: 50)
        }else if textField.tag == 2{
            moveView(up: false, distance: 80)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveView(up: Bool, distance: Int){
        let moveDuration = 0.3
        let movement : CGFloat = CGFloat(up ? -distance : distance)
        UIView.beginAnimations("viewAnimation", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
}
