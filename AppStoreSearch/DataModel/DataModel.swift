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
    
    static func makeAppEntityFromSource(_ dictionary: [String: Any]) -> AppEntity? {
        let viewContext = persistence.container.viewContext
        let appEntity = AppEntity(context: viewContext)
        for key in dictionary.keys {
            if key == "description" {
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
        
        guard appEntity.isValid() == true else { return nil }
        appEntity.id = UUID()
        DataModel.persistence.save()
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
                handle(results.apps, .okayNoErrorCode)
                print("appEntites count == \(results.apps.count)")
                
            } catch {
                print("AppStore Service Failed: \(error)")
            }
        }
        
        return (code: .okayNoErrorCode, message: message)
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


