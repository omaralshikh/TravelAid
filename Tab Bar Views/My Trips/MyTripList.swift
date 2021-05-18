//
//  MyTripList.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
import CoreData


struct MyTripList: View {
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ CoreData FetchRequest returning all trip entities in the database
    @FetchRequest(fetchRequest: Trip.allTripssFetchRequest()) var allTrips: FetchedResults<Trip>
    
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the trips in a dynamic scrollable list.
                 */
                ForEach(self.allTrips) { aSong in
                    NavigationLink(destination: MyTripDetails(trip: aSong)) {
                        MyTripItem(trip: aSong)
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
            .navigationBarTitle(Text("My Trip"), displayMode: .inline)
           
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: AddTrip()) {
                    Image(systemName: "plus")
                })
           
        }   // End of NavigationView
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())
    }
   
    /*
     ----------------------------
     MARK: - Delete Selected Song
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
       
        let songToDelete = self.allTrips[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(songToDelete)
 
        // ❎ CoreData Save operation
        do {
          try self.managedObjectContext.save()
        } catch {
          print("Unable to delete selected Trip!")
        }
    }
 
}

struct MyTripList_Previews: PreviewProvider {
    static var previews: some View {
        MyTripList()
    }
}
