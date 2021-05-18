//
//  Trip.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import Foundation
import CoreData
 

public class Trip: NSManagedObject, Identifiable {
    
    @NSManaged public var cost: NSNumber?
    @NSManaged public var endDate: String?
    @NSManaged public var notes: String?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var startDate: String?
    @NSManaged public var title: String?

    @NSManaged public var photo: Photo?
}

extension Trip {
    
    
    static func allTripssFetchRequest() -> NSFetchRequest<Trip> {
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest() as! NSFetchRequest<Trip>

        request.sortDescriptors = [
            // Primary sort key: rating
            NSSortDescriptor(key: "rating", ascending: false),
            // Secondary sort key: title
            NSSortDescriptor(key: "title", ascending: false)
        ]
       
        return request
    }
    
    static func filteredTripsFetchRequest(searchCategory: String, searchQuery: String) -> NSFetchRequest<Trip> {
       
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
       
        /*
         List the found trips in alphabetical order with respect to rating;
         If rating is the same, then sort with respect to title.
         */
        fetchRequest.sortDescriptors = [
            // Primary sort key: rating
            NSSortDescriptor(key: "rating", ascending: true),
            // Secondary sort key: title
            NSSortDescriptor(key: "title", ascending: true)
        ]
       
        // Case insensitive search [c] for searchQuery under each category
        
        switch searchCategory {
        case "Trip Cost":
            fetchRequest.predicate = NSPredicate(format: "cost <= %d", searchQuery)
        case "Trip End Date":
            fetchRequest.predicate = NSPredicate(format: "endDate CONTAINS[c] %@", searchQuery)
        case "Trip Notes":
            fetchRequest.predicate = NSPredicate(format: "notes CONTAINS[c] %@", searchQuery)
        case "Trip Rating":
            fetchRequest.predicate = NSPredicate(format: "rating CONTAINS[c] %@", searchQuery)
        case "Trip Start Date":
            fetchRequest.predicate = NSPredicate(format: "startDate CONTAINS[c] %@", searchQuery)
        case "Trip Title":
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchQuery)
        case "Compound":
            let components = searchQuery.components(separatedBy: "AND")
            let yearQuery = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let ratingQuery = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
 
            fetchRequest.predicate = NSPredicate(format: "startDate CONTAINS[c] %@ AND rating CONTAINS[c] %@", yearQuery, ratingQuery)
        default:
            print("Search category is out of range")
        }
       
        return fetchRequest
    }
 
}
 
