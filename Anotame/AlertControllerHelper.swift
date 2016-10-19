//
//  AlertControllerHelper.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/11/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import UIKit

class AlertControllerHelper{
    
    static let staticInstance = AlertControllerHelper()
    
    private init(){
        
    }
    
    func createDeleteDialog(title: String, message: String, deleteButtonTitle : String, deleteCompletion: ((UIAlertAction) -> Void)?) -> UIViewController{
        
        let deleteALV = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .destructive, handler: deleteCompletion)
        let cancelAction  = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        
        deleteALV.addAction(deleteAction)
        deleteALV.addAction(cancelAction)
        return deleteALV
        
    }
    
    func createSimpleDialog(title: String, message: String, okButtonTitle: String, okCompletion: ((UIAlertAction) ->Void)?) -> UIAlertController{
        
        let simpletAVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: okCompletion)
        let cancelAction  = UIAlertAction(title: "No gracias!", style: .default, handler: nil)
        

        simpletAVC.addAction(okAction)
        simpletAVC.addAction(cancelAction)
        return simpletAVC
    }
    
    func createErrorMessageDialog(title : String, errorMessage : String) -> UIAlertController{
        let errorAVC = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        errorAVC.addAction(okAction)
        return errorAVC
    }
    
}
