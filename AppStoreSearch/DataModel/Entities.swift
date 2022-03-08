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
    @NSManaged public var appDescription: String
    @NSManaged public var category: String
    @NSManaged public var price: String
    @NSManaged public var size: String
}
