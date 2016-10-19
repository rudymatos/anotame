//
//  BoardImpl.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/11/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

class BoardImpl : BoardType{
    
    private let cdHelper = CoreDataHelper.staticInstance
    private let udHelper = UserDefaultsHelper.staticInstance
    
    func getCurrentActiveBoard()throws -> Board{
        do{
            //first check if there is a league avaiable if not then create it
            let league = try cdHelper.getActiveLeague() ?? cdHelper.createLeague(leagueName: League.default_league_name, icon: League.default_league_icon)
            //check if board is available if not then create it
            let board = try cdHelper.getActiveBoardInLeague(league: league!) ?? cdHelper.createBoard(league: league!)
            return board
        }catch AnotameError.ActiveBoardFound {
            throw AnotameError.ActiveBoardFound
        }catch AnotameError.LeagueAlreadyExist{
            throw AnotameError.LeagueAlreadyExist
        }catch{
            throw AnotameError.ErrorCreatingDefaultBoard
        }
    }
    
    
    func publishBoard(board: Board){
        
    }
    
    func addPlayerToLeague(player:Player, league: League){
        
    }
    
    func addPlayerToBoard(player:Player, board: Board){
        
    }
    
    
    
    
    
}
