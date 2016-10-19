//
//  UserDefaultHelper.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/13/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsHelper{
    
    static let staticInstance = UserDefaultsHelper()
    private let userDefaulInstance = UserDefaults.standard
    
    private init(){
    }
    
    func getActiveLeagueName() -> String?{
        return userDefaulInstance.string(forKey: "currentActiveLeague")
    }
    
}
