//
//  TravelData.swift
//  TravelAid
//
//  Created by Omar on 10/24/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
import CoreData
 
// Array of travel structs for use only in this file
fileprivate var TravelStructList = [Travel]()
 
/*
 ***********************************
 MARK: - Create travel Database
 ***********************************
 */
public func createTravelDatabase() {
 
    TravelStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "TravelData.json", fileLocation: "Main Bundle")
   
    populateDatabase()
}
 
/*
*********************************************
MARK: - Populate Database If Not Already Done
*********************************************
*/
func populateDatabase() {
   
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
    fetchRequest.sortDescriptors = [
        // Primary sort key: artistName
        NSSortDescriptor(key: "rating", ascending: false),
        // Secondary sort key: songName
        NSSortDescriptor(key: "title", ascending: false)
    ]
   
    var listOfAllSongEntitiesInDatabase = [Trip]()
   
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllSongEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
   
    if listOfAllSongEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
   
    print("Database will be populated!")
   
    for trav in TravelStructList {
        /*
         =====================================================
         Create an instance of the travel Entity and dress it up
         =====================================================
        */
       
        // ❎ Create an instance of the Song entity in CoreData managedObjectContext
        let tripEntity = Trip(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        var Tcost = tripEntity.cost!.doubleValue
        var Trating = tripEntity.rating!.intValue
        Tcost = trav.cost
        tripEntity.cost = NSNumber(value: Tcost)
        tripEntity.endDate = trav.endDate
        tripEntity.notes = trav.notes
        Trating = trav.rating
        tripEntity.rating = NSNumber(value: Trating)
        tripEntity.startDate = trav.startDate
        tripEntity.title = trav.title
        
  
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
       
        // ❎ Create an instance of the Photo Entity in CoreData managedObjectContext
        let photoEntity = Photo(context: managedObjectContext)
        var lat = photoEntity.latitude!.doubleValue
        var long = photoEntity.longitude!.doubleValue
        photoEntity.dateTime = trav.photoDateTime
        lat = trav.photoLatitude
        photoEntity.latitude = NSNumber(value: lat)
        long = trav.photoLongitude
        photoEntity.longitude = NSNumber(value: long)

        
       
        // Obtain the album cover photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: trav.photoFilename)
       
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
       
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        photoEntity.tripPhoto = photoData!
       
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // ❎ Establish Relationship between entities trip and Photo
        tripEntity.photo = photoEntity
        photoEntity.Trip = tripEntity
       
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
       
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of for loop
 
}
 
