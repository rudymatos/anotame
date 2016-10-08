//
//  CoreDataHelper.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper{
    
    static let staticInstance = CoreDataHelper()
    private var managedObjectContext : NSManagedObjectContext
    
    private init(){
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    func initEssentialData(){
//        
//        let pointGuard = createObject(entityName: "PlayerPosition") as! PlayerPosition
//        let shootingGuard = createObject(entityName: "PlayerPosition") as! PlayerPosition
//        let smallForward = createObject(entityName: "PlayerPosition") as! PlayerPosition
//        let powerForward = createObject(entityName: "PlayerPosition") as! PlayerPosition
//        let center = createObject(entityName: "PlayerPosition") as! PlayerPosition
//        
//        pointGuard.name = PlayerPositionEnum.PointGuard.rawValue
//        pointGuard.icon = PlayerPositionEnum.PointGuard.getPositionImageName()
//        shootingGuard.name = PlayerPositionEnum.ShootingGuard.rawValue
//        shootingGuard.icon = PlayerPositionEnum.ShootingGuard.getPositionImageName()
//        smallForward.name = PlayerPositionEnum.SmallForward.rawValue
//        smallForward.icon = PlayerPositionEnum.SmallForward.getPositionImageName()
//        powerForward.name = PlayerPositionEnum.PowerForward.rawValue
//        powerForward.icon = PlayerPositionEnum.PowerForward.getPositionImageName()
//        center.name = PlayerPositionEnum.Center.rawValue
//        center.icon = PlayerPositionEnum.Center.getPositionImageName()
////
////        saveContext()
////        
//        
//        let guest = createObject(entityName: "PlayerType") as! PlayerType
//        let member = createObject(entityName: "PlayerType") as! PlayerType
//        
//        guest.name = PlayerTypeEnum.Guest.rawValue
//        guest.icon = PlayerTypeEnum.Guest.rawValue.lowercased()
//        
//        member.name = PlayerTypeEnum.Member.rawValue
//        member.icon = PlayerTypeEnum.Member.rawValue.lowercased()
//        saveContext()
//        print(getPlayerType(playerType: PlayerTypeEnum.Member)?.name)
//        print(getPlayerType(playerType: PlayerTypeEnum.Member)?.icon)
//        
        do{
//            try createLeague(leagueName: "Liga Sharks", icon: "sharks")
//            let player = createObject(entityName: "Player") as! Player
            if let league = getLeagueByNameAndActive(leagueName: "Liga Sharks"){
//                createPlayer(name: "Rudy Matos", nick: "rudymatos", number: 87, league: league, playerType: PlayerTypeEnum.Member, positions: NSSet(array: [pointGuard, shootingGuard]))
//                createPlayer(name: "Alison Perez", nick: "Guabi", number: 30, league: league, playerType: PlayerTypeEnum.Member, positions: NSSet(array: [pointGuard]))
//
                
//                createPlayer(name: "Ramon Mena", nick: "Guebi", number: 3, league: league, playerType: PlayerTypeEnum.Member, positions: NSSet())
//                
//                if let rudy = getPlayerByNameAndLeagueName(playerName: "Rudy Matos", leagueName: league.name!){
//                    print(rudy.name)
//                }
//                if let results = getPlayerByNameLikeAndLeagueName(playerName: "Ali", leagueName: league.name!){
//                    print(results.first?.name)
//                }
//                
//                if let results = getPlayerByNameLikeAndLeagueName(playerName: "Ramo", leagueName: league.name!){
//                    if let ramon = results.first{
//                        addPlayerToLeague(player: ramon, league: league)
//                    }
//                }
                
//                if let players = league.players{
//                    for player in players{
//                        print("Player name : \((player as! Player).name)")
//                    }
//                }
//                if let players = getLeagueMembers(league: league){
//                    for player in players{
//                        print("Player name: \(player.name)")
//                    }
//                }
                
                
                
//                try createBoard(league: league)
                if let board = getActiveBoardInLeague(league: league){
//                board?.addToArriving_order_list(league.players?.filter({($0 as! Player).name!.contains("Rudy")}).first as! Player)
//                board?.addToArriving_order_list(league.players?.filter({($0 as! Player).name!.contains("Alison")}).first as! Player)
//                saveContext()

                    for player in board.arriving_order_list!{
                        print((player as! Player).name)
                    }
                }
                
            }
        }catch AnotameError.ActiveBoardFound(let message){
            print(message)
        }catch let error as NSError{
            print(error)
        }
        
        
        
    }
    
    func createObject(entityName: String) -> NSManagedObject{
        //TODO: validate entityName is valid
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext)
    }
    
    func saveContext(){
        do{
            try self.managedObjectContext.save()
        }catch let error as NSError{
            print("Error \(error) Error message : \(error.userInfo)")
//            throw AnotameError.CoreDataError()
        }

    }
    //MARK: -Team Methods
    
    
    //MARK: -Events Methods
    func createEvents(player: Player, board: Board, team : Team){
        
    }
    
    //MARK: -Board Methods
    func getActiveBoardInLeague(league: League) -> Board?{
        let request : NSFetchRequest<Board> = Board.fetchRequest()
        request.predicate = NSPredicate(format: "league.name = %@", league.name!)
        request.fetchLimit = 1
        do{
            let results = try managedObjectContext.fetch(request)
            if results.count == 0{
                return nil
            }
            return results.first
        }catch let error as NSError{
            print(error)
            return nil
        }
        
    }
    
    func doesActiveBoardExistInLeague(forLeague league: League)-> Bool{
        let request : NSFetchRequest<Board> = Board.fetchRequest()
        request.predicate = NSPredicate(format: "league.name = %@ and active = true", league.name!)
        request.fetchLimit = 1
        do{
            let results = try managedObjectContext.fetch(request)
            if results.count == 0{
                return false
            }
            return true
        }catch let error as NSError{
            return false
        }
        
    }
    
    func createBoard(league : League)throws{
        if !doesActiveBoardExistInLeague(forLeague: league){
            let board = NSEntityDescription.insertNewObject(forEntityName: Board.entityName, into: self.managedObjectContext) as! Board
            board.creation_date = NSDate()
            board.league = league
            board.active = true
            saveContext()
        }else{
            throw AnotameError.ActiveBoardFound(message: "Una pizarra se cuentra actualmente activa en esta liga")
        }
    }
    
    //MARK: -Player Methods
    func createPlayer(name : String, nick: String?, number : Int, league: League, playerType : PlayerTypeEnum, positions : NSSet){
        let player = NSEntityDescription.insertNewObject(forEntityName: Player.entityName, into: managedObjectContext) as! Player
        player.name = name
        player.nick = nick ?? ""
        player.number = Int16(number)
        player.league = league
        player.player_type = getPlayerType(playerType: playerType)
        player.positions = positions
        saveContext()
    }
    
    func addPlayerToLeague(player : Player, league: League){
        league.addToPlayers(player)
        saveContext()
    }
    
    func getPlayerByNameAndLeagueName(playerName: String, leagueName: String) -> Player?{
        let request : NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@ and league.name = %@", playerName, leagueName)
        request.sortDescriptors = [NSSortDescriptor(key:"name", ascending : true)]
        request.fetchLimit = 1
        do{
            let results = try managedObjectContext.fetch(request)
            if results.count == 0{
                return nil
            }
            return results.first
        }catch let error as NSError{
            print (error)
            return nil
        }
        
        
    }
    
    func getPlayerByNameLikeAndLeagueName(playerName: String, leagueName: String) -> [Player]?{
        let request : NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ and league.name = %@" , playerName, leagueName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do{
            let managedObjects = try managedObjectContext.fetch(request)
            if managedObjects.count == 0{
                return nil
            }
                return managedObjects
        }catch let error as NSError{
            print(error)
            return nil
        }
    }
    
    func getPlayerType(playerType: PlayerTypeEnum) -> PlayerType?{
        let request = PlayerType.fetchRequest() as NSFetchRequest<PlayerType>
        request.fetchLimit = 1
        request.predicate  = NSPredicate(format: "name = %@", playerType.rawValue)
        do{
            let managedObjects = try managedObjectContext.fetch(request)
            if managedObjects.count == 0{
                print("There is not player type in the db. Rudy... Pleaseee!")
                throw NSError()
            }
            return managedObjects.first!
        }catch let error as NSError{
            print("Error \(error) Error message : \(error.userInfo)")
            return nil
        }
    }
    
    func getLeagueMembers(league: League) -> [Player]?{
        let request : NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "league.name = %@", league.name!)
        return try? managedObjectContext.fetch(request)
    }
    
    
    //MARK: -League Methods
    func getLeagueByNameAndActive(leagueName name: String) -> League?{
        let request : NSFetchRequest<League> = League.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@ and active = true", name)
        request.fetchLimit = 1
        do{
            let managedObjects = try managedObjectContext.fetch(request)
            if managedObjects.count == 0{
                return nil
            }
            return managedObjects.first
        }catch{
            return nil
        }
    }
    
    func doesLeagueExists(leagueName name : String) -> Bool{
        guard getLeagueByNameAndActive(leagueName: name) != nil else{
            return false
        }
        return true
    }
    
    func createLeague(leagueName name: String, icon: String )throws{
        if !doesLeagueExists(leagueName: name){
            let currentLeagueToCreate = createObject(entityName: League.entityName) as! League
            currentLeagueToCreate.active = true
            currentLeagueToCreate.name = name
            currentLeagueToCreate.icon = icon
            currentLeagueToCreate.creation_date = NSDate()
            saveContext()
        }else{
                throw AnotameError.LeagueAlreadyExist(message: "Existe una liga activa con este nombre en este dispositivo")
        }
        
    }
    
}
