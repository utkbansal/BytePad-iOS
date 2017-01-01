//
//  Download+CoreDataProperties.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 01/01/17.
//  Copyright © 2017 Software Incubator. All rights reserved.
//

import Foundation
import CoreData


extension Download {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Download> {
        return NSFetchRequest<Download>(entityName: "Download");
    }

    @NSManaged public var fileName: String
    @NSManaged public var filePath: String?

}
