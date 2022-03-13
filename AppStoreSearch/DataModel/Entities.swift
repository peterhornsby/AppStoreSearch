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
    @NSManaged public var id: Int64
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
}
