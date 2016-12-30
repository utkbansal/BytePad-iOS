//
//  Paper+CoreDataProperties.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 31/12/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import Foundation
import CoreData


extension Paper {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Paper> {
        return NSFetchRequest<Paper>(entityName: "Paper");
    }

    @NSManaged public var examTypeID: NSNumber?
    @NSManaged public var fileURL: String?
    @NSManaged public var semester: NSNumber?
    @NSManaged public var name: String?

}
