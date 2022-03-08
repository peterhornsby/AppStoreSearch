//
//  DataModel.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import Foundation
import CoreData
import os.log

// Logging
fileprivate let logger = Logger()

struct DataModel {
    
    // A singleton for our entire app to use
    static let persistence = PersistenceController()

    static func makeAppEntity(_ name: String,
                              _ appDescription: String,
                              _ category: String,
                              _ price: String,
                              _ size: String) -> AppEntity? {
        
        guard validateAppEntityParameters(name,
                                          appDescription,
                                          category,
                                          price, size) == true else {
            logger.error("\(#function) - error: AppEntity parameters failed validation.")
            return nil
        }
        
        let viewContext = persistence.container.viewContext
        let appEntity = AppEntity(context: viewContext)
        
        appEntity.id = UUID()
        appEntity.name = name
        appEntity.appDescription = appDescription
        appEntity.category = category
        appEntity.price = price
        appEntity.size = size
        
        persistence.save()
        return appEntity
    }
    
    
    static func validateAppEntityParameters(_ name: String,
                                            _ appDescription: String,
                                            _ category: String,
                                            _ price: String,
                                            _ size: String) -> Bool {
        
        guard name.isEmpty == false else {
            logger.error("\(#function) - error: AppEntity name parameter failed validation.")
            return false
        }
        
        guard appDescription.isEmpty == false else {
            logger.error("\(#function) - error: AppEntity appDescription parameter failed validation.")
            return false
        }
        
        guard category.isEmpty == false else {
            logger.error("\(#function) - error: AppEntity category parameter failed validation.")
            return false
        }
        
        guard price.isEmpty == false else {
            logger.error("\(#function) - error: AppEntity price parameter failed validation.")
            return false
        }
        
        return true
    }
    
}




// MARK: - CoreData tech Stack
struct PersistenceController {

    // Storage for Core Data
    let container: NSPersistentContainer

    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: false)

        return controller
    }()

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    fileprivate init(inMemory: Bool = false) {

        container = NSPersistentContainer(name: "AppStoreSearch")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                logger.critical("Critical Error with: \(#function) - \(error.localizedDescription)")
                /// pjh: remove when time to release
                fatalError()
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        guard context.hasChanges == true else { return }
        
        do {
            try context.save()
        } catch {
            // Show some error here
            logger.critical("Critical Error with: \(#function) - \(error.localizedDescription)")
            
            /// pjh: remove when time to release
            fatalError()
        }
    }
    
}


