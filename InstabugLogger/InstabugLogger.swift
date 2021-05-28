//
//  InstabugLogger.swift
//  InstabugLogger
//
//  Created by Yosef Hamza on 19/04/2021.
//

import Foundation
import CoreData

public class InstabugLogger {
    
    
    public static var shared = InstabugLogger()
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LogModel")
        container.loadPersistentStores { (storeDescription, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        }
        return container
    }()
    
    lazy var context = persistentContainer.newBackgroundContext()
    
    // MARK: Logging
    public func log(_ level: logLevel, message: String) {
        let finalMessage = message.toLessThan1000Chars()
        Swift.print("\(Date().toString()) [\(level.rawValue)]: \(finalMessage)")
        saveLog(level: level, message: finalMessage)
    }
    
    // MARK: Fetch logs
    public func fetchAllLogs() -> [LogEntity] {
        var logs:[LogEntity] = []
        
        context.performAndWait({
            let fetchRequest = NSFetchRequest<LogEntity>(entityName: "LogEntity")
            do {
                logs = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        })
        return logs
    }
    
    public func fetchAllLogs(completionHandler: @escaping ([LogEntity]) -> Void ) {
        
        context.perform {
            let fetchRequest = NSFetchRequest<LogEntity>(entityName: "LogEntity")
            do {
                let logs = try self.context.fetch(fetchRequest)
                completionHandler(logs)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func saveLog(level: logLevel, message: String) {
        
        deleteEarliestLog()
        context.perform {
            
            let log = LogEntity(context: self.context)
            log.level = level.rawValue
            log.message = message
            log.timeStamp = Date()
            
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteEarliestLog() {
        
        context.perform {
            let fetchedResults = NSFetchRequest<NSManagedObject>(entityName: "LogEntity")
            
            do{
                let result = try self.context.fetch(fetchedResults)
                
                if result.count >= 1000 {
                    self.context.delete(result.first!)
                    try self.context.save()
                }
            } catch let error as NSError {
                print("Could not delete earliest log. \(error), \(error.userInfo)")
            }
        }
    }
    
    public func deleteAllLogs() {
        fetchAllLogs { logs in
            self.context.perform {
                do {
                    for log in logs {
                        self.context.delete(log)
                    }
                    try self.context.save()
                } catch let error as NSError{
                    print("Could not delete all logs. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
}
