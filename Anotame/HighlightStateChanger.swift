//
//  HighlightStateChanger.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/16/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

protocol HighlightStateChanger{
    var state: Bool {get}
    func changeHighlightState()
}
