//
//  Photo.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import Foundation
import CoreData
 

public class Photo: NSManagedObject, Identifiable {
    
    @NSManaged public var dateTime: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var tripPhoto: Data?
    @NSManaged public var Trip: Trip?
}

