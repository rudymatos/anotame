//
//  ViewController.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let coreDataHelper = CoreDataHelper.staticInstance
    private let alertControllerHelper = AlertControllerHelper.staticInstance
    private let boardImpl = BoardImpl()
    private var currentActiveBoard : Board?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    private var isThereABoardCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        checkAppWasLaunchBefore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: -MAIN CLASS METHODS
    
    func checkAppWasLaunchBefore(){
        if   UserDefaults.standard.string(forKey: "applicationWasAlreadyLunch") == nil{
            print("Data was not found. Creating initial data")
            coreDataHelper.initEssentialData()
        }
    }
    
    func configureView(){
        animateView(view: topView, distance: -120)
        animateView(view: bottomView, distance: 120, withDelay: 0.3)
    }
    
    func animateView(view: UIView, distance: CGFloat,  withDelay : Double = 0.0){
        
        let y = view.center.y
        view.center.y += distance
        
        UIView.animate(withDuration: 0.75, delay: withDelay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            view.center.y = y
            }, completion: nil)
        
    }
    
    
    //MARK: -TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @IBAction func changeViewDidTouch(_ sender: UIButton) {
        print("here a;aslkadf")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPlayerSegue"{
            let playerSearchVC = segue.destination as! PlayerSearchVC
            playerSearchVC.currentActiveBoard = currentActiveBoard
        }
    }
    
    @IBAction func addPlayerDidTouch(_ sender: UIButton) {
        do{
            currentActiveBoard = try boardImpl.getCurrentActiveBoard()
            performSegue(withIdentifier: "addPlayerSegue", sender: nil)
        }catch {
            //            self.alertControllerHelper.createErrorMessageDialog(title: "Error al agregar usuario", errorMessage: error.r)
        }
        
    }
}

