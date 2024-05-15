//
//  LanguageBookmarksEntity+CoreDataProperties.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/15/24.
//
//

import Foundation
import CoreData


extension LanguageBookmarksEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LanguageBookmarksEntity> {
        return NSFetchRequest<LanguageBookmarksEntity>(entityName: "LanguageBookmarksEntity")
    }

    @NSManaged public var id: Int16

}

extension LanguageBookmarksEntity : Identifiable {

}
