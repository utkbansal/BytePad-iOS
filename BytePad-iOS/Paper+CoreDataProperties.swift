//
//  Paper+CoreDataProperties.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 30/12/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import Foundation
import CoreData


extension Paper {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Paper> {
        return NSFetchRequest<Paper>(entityName: "Paper");
    }

    @NSManaged public var fileURL: String?
    @NSManaged public var examTypeID: Int16
    @NSManaged public var semester: Int16

}
