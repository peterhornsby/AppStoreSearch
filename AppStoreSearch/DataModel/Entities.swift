//
//  Entities.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import Foundation
import CoreData
import os.log


@objc(AppEntity)
public class AppEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var version: String
    @NSManaged public var developer: String
    @NSManaged public var appDescription: String
    @NSManaged public var category: String
    @NSManaged public var price: String
    @NSManaged public var size: String
    @NSManaged public var artworkURL: String
    
    
    func isFree() -> Bool {
        // pjh: need to handle trash values
        guard let number = Double(price) else { return false }
        guard number == 0.0  else { return false }
        return true
    }
    
    func isValid() -> Bool {
        guard name.isEmpty == false,
              version.isEmpty == false,
              developer.isEmpty == false,
              appDescription.isEmpty == false,
              category.isEmpty == false,
              price.isEmpty == false,
              size.isEmpty == false,
              artworkURL.isEmpty == false else { return false }
        
        return true
    }
}
