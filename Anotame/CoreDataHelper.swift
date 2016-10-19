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
        
        let pointGuard = createObject(entityName: "PlayerPosition") as! PlayerPosition
        let shootingGuard = createObject(entityName: "PlayerPosition") as! PlayerPosition
        let smallForward = createObject(entityName: "PlayerPosition") as! PlayerPosition
        let powerForward = createObject(entityName: "PlayerPosition") as! PlayerPosition
        let center = createObject(entityName: "PlayerPosition") as! PlayerPosition
        pointGuard.name = PlayerPositionEnum.PointGuard.rawValue
        pointGuard.icon = PlayerPositionEnum.PointGuard.getPositionImageName()
        shootingGuard.name = PlayerPositionEnum.ShootingGuard.rawValue
        shootingGuard.icon = PlayerPositionEnum.ShootingGuard.getPositionImageName()
        smallForward.name = PlayerPositionEnum.SmallForward.rawValue
        smallForward.icon = PlayerPositionEnum.SmallForward.getPositionImageName()
        powerForward.name = PlayerPositionEnum.PowerForward.rawValue
        powerForward.icon = PlayerPositionEnum.PowerForward.getPositionImageName()
        center.name = PlayerPositionEnum.Center.rawValue
        center.icon = PlayerPositionEnum.Center.getPositionImageName()
        
        let guest = createObject(entityName: "PlayerType") as! PlayerType
        let member = createObject(entityName: "PlayerType") as! PlayerType
        
        guest.name = PlayerTypeEnum.Guest.rawValue
        guest.icon = PlayerTypeEnum.Guest.rawValue.lowercased()
        
        member.name = PlayerTypeEnum.Member.rawValue
        member.icon = PlayerTypeEnum.Member.rawValue.lowercased()
        saveContext()
        
    }
    
    func createObject(entityName: String) -> NSManagedObject{
        //TODO: validate entityName is valid
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext)
    }
    
    func saveContext(){
        do{
            try self.managedObjectContext.save()
            managedObjectContext.refreshAllObjects()
        }catch let error as NSError{
            print("Error \(error) Error message : \(error.userInfo)")
            //            throw AnotameError.CoreDataError()
        }
        
    }
    
    //MARK: -Other Methods
    func getAllPositions() -> [PlayerPosition]{
        let request : NSFetchRequest<PlayerPosition> = PlayerPosition.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let results = try! managedObjectContext.fetch(request)
        return results
    }
    
    func getAllPlayerTypes() -> [PlayerType]?{
        let request : NSFetchRequest<PlayerType> = PlayerType.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        return try! managedObjectContext.fetch(request)
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
        }catch _ {
            return false
        }
        
    }
    
    func createBoard(league : League)throws ->Board{
        if !doesActiveBoardExistInLeague(forLeague: league){
            let board = NSEntityDescription.insertNewObject(forEntityName: Board.entityName, into: self.managedObjectContext) as! Board
            board.creation_date = NSDate()
            board.league = league
            board.active = true
            saveContext()
            return board
        }else{
            throw AnotameError.ActiveBoardFound
        }
    }
    
    //MARK: -Player Methods
    func createPlayer(name : String, nick: String?, number : Int, league: League, playerType : PlayerType, positions : NSSet, image: NSData?){
        let player = NSEntityDescription.insertNewObject(forEntityName: Player.entityName, into: managedObjectContext) as! Player
        player.name = name
        player.nick = nick ?? ""
        player.number = Int16(number)
        player.league = league
        player.player_type = playerType
        player.positions = positions
        player.photo = image
        saveContext()
    }
    
    func addPlayerToLeague(player : Player, league: League){
        league.addToPlayers(player)
        saveContext()
    }
    
    func doesPlayerAlreadyExist(playerName: String, playerNumber:  Int, leagueName: String) -> Bool{
        var doesPlayerAlreadyExist = false
        let request : NSFetchRequest<Player> = Player.fetchRequest()
        do{
        request.predicate = NSPredicate(format: "name = %@ and number = %i and league.name = %@", playerName, playerNumber, leagueName)
        let results = try managedObjectContext.fetch(request)
            if results.count > 0{
                doesPlayerAlreadyExist = true
            }
        }catch let error as NSError{
            print(error)
        }
        return doesPlayerAlreadyExist
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
    
    func deletePlayer(player : Player){
        managedObjectContext.delete(player)
        saveContext()
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
    
    func getActiveLeague() -> League?{
        
        let request: NSFetchRequest<League> = League.fetchRequest()
        request.predicate = NSPredicate(format: "active = YES")
        request.fetchLimit = 1
        
        do{
            let results = try managedObjectContext.fetch(request)
            if results.count == 0{
                return nil
            }
            return results.first!
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
    
    func createLeague(leagueName name: String, icon: String )throws -> League?{
        if !doesLeagueExists(leagueName: name){
            let currentLeagueToCreate = createObject(entityName: League.entityName) as! League
            currentLeagueToCreate.active = true
            currentLeagueToCreate.name = name
            currentLeagueToCreate.icon = icon
            currentLeagueToCreate.creation_date = NSDate()
            saveContext()
            return currentLeagueToCreate
        }else{
            throw AnotameError.LeagueAlreadyExist
        }
        
    }
    
}
