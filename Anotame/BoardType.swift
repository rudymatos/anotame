//
//  BoardType.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/11/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

protocol BoardType {
    
    func getCurrentActiveBoard()throws -> Board
    func publishBoard(board: Board)
    func addPlayerToLeague(player:Player, league: League)
    func addPlayerToBoard(player:Player, board: Board)
    
}
