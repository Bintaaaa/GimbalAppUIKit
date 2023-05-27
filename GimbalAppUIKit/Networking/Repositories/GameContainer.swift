//
//  GameContainer.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 28/05/23.
//

import CoreData
import UIKit


class GameContainer{
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GimbalData")
        
        container.loadPersistentStores{_, error in
            guard error == nil else{
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext{
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllGames(completion: @escaping(_ games: [GameEntity]) -> Void){
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gimbal")
            
            do{
                let results = try taskContext.fetch(fetchRequest)
                var games: [GameEntity] = []
                for result in results{
                    let member = GameEntity(
                        id: result.value(forKey: "id") as! Int32,
                        title: result.value(forKey: "title") as! String,
                        imagePath: result.value(forKey: "image") as! URL,
                        level: result.value(forKey: "level") as! Int32,
                        releaseDate: result.value(forKey: "releaseDate") as! Date)
                    
                    games.append(member)
                }
                completion(games)
            }catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addToFavorite(
        id: Int32,
        title: String,
        image: URL,
        level: Int32,
        releeaseDate: Date,
        completion: @escaping() -> Void
    ){
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Gimbal", in: taskContext){
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                
                game.setValue(id, forKey: "id")
                game.setValue(title, forKey: "title")
                game.setValue(image, forKey: "image")
                game.setValue(releeaseDate, forKey: "releaseDate")
            }
            do{
                try taskContext.save()
                completion()
            } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
    func isFavorite(id: Int32, completion: @escaping(_ isFavorite: Bool) -> Void){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gimbal")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do{
                if let result  = try taskContext.fetch(fetchRequest).first{
                    let isFavorite = id == result.value(forKey: "id")  as? Int32
                    completion(isFavorite)
                }
            }catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteFavorite(id: Int32, completion: @escaping() -> Void){
        let taskContext = newTaskContext()
        taskContext.perform {
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gimbal")
          fetchRequest.fetchLimit = 1
          fetchRequest.predicate = NSPredicate(format: "id == \(id)")
          let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
          batchDeleteRequest.resultType = .resultTypeCount
          if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            if batchDeleteResult.result != nil {
              completion()
            }
          }
        }
    }
}
