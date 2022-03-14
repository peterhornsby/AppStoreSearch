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
    static let viewContext = persistence.container.viewContext
    
    static func makeAppEntityFromSource(_ dictionary: [String: Any]) -> AppEntity? {
        var appEntity = AppEntity(context: viewContext)
        for key in dictionary.keys {
            if key == "trackId" {
                if let id = dictionary["trackId"] as? Int64 {
                    if let existingAppEntity = entity(with: id) {
                        appEntity = existingAppEntity
                        break
                    } else {
                        appEntity.id = id
                    }
                }
            } else if key == "description" {
                if let text = dictionary["description"] as? String {
                    appEntity.appDescription = text
                }
            } else if key == "trackName" {
                if let text = dictionary["trackName"] as? String {
                    appEntity.name = text
                }
            } else if key == "primaryGenreName" {
                if let text = dictionary["primaryGenreName"] as? String {
                    appEntity.category = text
                }
            } else if key == "price" {
                if let number = dictionary["price"] as? Double {
                    appEntity.price = "\(number)"
                }
            } else if key == "version" {
                if let text = dictionary["version"] as? String {
                    appEntity.version = text
                }
            } else if key == "artistName" {
                if let text = dictionary["artistName"] as? String {
                    appEntity.developer = text
                }
            } else if key == "fileSizeBytes" {
                if let text = dictionary["fileSizeBytes"] as? String {
                    appEntity.size = text
                }
            } else if key == "artworkUrl512" {
                if let text = dictionary["artworkUrl512"] as? String {
                    appEntity.artworkURL = text
                }
            }
        }
        
        guard isAppEntityValid(appEntity) == true else { return nil }
        return appEntity
    }
    
    // pjh: used by AppStoreSearch service json -> coredata
    static func queryForApps(term: String?, handle: @escaping([AppEntity], ApplicationErrorType) -> ()) -> (code:ApplicationErrorType, message:String) {
        var message = "Search term is nil"
        guard let text = term else {
            handle([], .searchTermIsNilErrorCode)
            return (code: .nilStringErrorCode, message: message)
        }
        
        guard text.isEmpty == false else {
            message = "Search term is empty"
            handle([], .searchTermIsEmptyErrorCode)
            return (code: .emptyStringErrorCode, message: message)
        }
        
        guard let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            message = "Search term could not be url encoded!"
            handle([], .urlEncodingErrorCode)
            return (code: .urlEncodingErrorCode, message: message)
        }
        
        logger.info("Query term is: \(encoded)")
        logger.info("Data Model will Attempt to build http query and pass to network service")
        
        
        message = "request made to AppStore service"

        // pjh: call site for AppStore Service
        Task {
            do {
                let results = try await AppStoreService.queryStore(term: encoded, makeAppEntity: DataModel.makeAppEntityFromSource)
                persistence.save()
                handle(results.apps, .okayNoErrorCode)
                print("appEntites count == \(results.apps.count)")
                
            } catch {
                print("AppStore Service Failed: \(error)")
            }
        }
        
        return (code: .okayNoErrorCode, message: message)
    }
    
    static func isAppEntityValid(_ entity: AppEntity?) -> Bool {
        
        guard let id = entity?.id, id != 0  else { return false }
        
        guard entity?.name.isEmpty == false,
              entity?.version.isEmpty == false,
              entity?.developer.isEmpty == false,
              entity?.appDescription.isEmpty == false,
              entity?.category.isEmpty == false,
              entity?.price.isEmpty == false,
              entity?.size.isEmpty == false,
              entity?.artworkURL.isEmpty == false else { return false }
        
        return true
    }
    
    
    static func entity(with id: Int64) -> AppEntity? {
        let fetchRequest =  NSFetchRequest<AppEntity>(entityName: "AppEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        
        do {
            let entity = try viewContext.fetch(fetchRequest).first
            return entity
        } catch {
            Logger().info("\(#function) is unable to fetch local entity")
        }
        
        return nil
    }
    
    
    
    static func genres(from dataSource: [AppEntity]) -> [String] {
        let results = Set(dataSource.map { $0.category })
        return Array(results)
    }
    
    
    
    // pjh: Persistence model has not been locked down. Right now just  REMOVE everything and start a new search
    static func deleteALLPreviousSearchResults() {
        deleteALLSearchResults()
    }
    
    
    private static func deleteALLSearchResults() {
        deleteALLAppEntities()
        removeALLMediaAssets()
    }
    
    
    private static func deleteALLAppEntities() {
        let viewContext = persistence.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppEntity")
        let batchRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try viewContext.execute(batchRequest)
            
        } catch {
            Logger().error("\(#function) failed to delete all app entities")
            
        }
        

        persistence.save()
    }
    
    
    private static func removeALLMediaAssets() {
        FileSystemService.removeALLMediaAssets()
    }
    
}




// MARK: - CoreData tech Stack
struct PersistenceController {

    // Storage for Core Data
    let container = NSPersistentContainer(name: "AppStoreSearch")

    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: false)

        return controller
    }()

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    fileprivate init(inMemory: Bool = false) {

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
            //fatalError()
        }
    }
    
}


