//
//  Paper+CoreDataProperties.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 04/04/17.
//  Copyright © 2017 Software Incubator. All rights reserved.
//

import Foundation
import CoreData


extension Paper {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Paper> {
        return NSFetchRequest<Paper>(entityName: "Paper")
    }

    @NSManaged public var exam: String?
    @NSManaged public var fileURL: String?
    @NSManaged public var name: String?
    @NSManaged public var session: String?

}
