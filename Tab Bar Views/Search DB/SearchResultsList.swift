//
//  SearchResultsList.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
import CoreData


struct SearchResultsList: View {
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    // ❎ CoreData FetchRequest returning filtered trip entities from the database
    @FetchRequest(fetchRequest: Trip.filteredTripsFetchRequest(searchCategory: searchCategory, searchQuery: searchQuery)) var filteredTrips: FetchedResults<Trip>
   
    var body: some View {
        if self.filteredTrips.isEmpty {
            SearchResultsEmpty()
        } else {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Songs in a dynamic scrollable list.
                 */
                ForEach(self.filteredTrips) { aSong in
                    NavigationLink(destination: SearchResultsDetails(trip: aSong)) {
                        SearchResultsItem(trip: aSong)
                    }
                }
               
            }   // End of List
            .navigationBarTitle(Text("Trips Found"), displayMode: .inline)
        }   // End of if
    }
}
 
struct SearchResultsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsList()
    }
}
 
