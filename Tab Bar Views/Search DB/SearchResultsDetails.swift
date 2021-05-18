//
//  SearchResultsDetails.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
import MapKit
import CoreData




struct SearchResultsDetails: View {
    let trip: Trip
    
    @FetchRequest(fetchRequest: Trip.allTripssFetchRequest()) var allSongs: FetchedResults<Trip>

    
    var body: some View {
        Form {
            Section(header: Text("Trip Title")) {
                Text(trip.title ?? "")
            }
            Section(header: Text("Trip Photo")) {
                // This public function is given in UtilityFunctions.swift
                photoImageFromBinaryData(binaryData: trip.photo!.tripPhoto!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)       
            }
            Section(header: Text("Trip Cost")) {
                tripCost
            }
            Section(header: Text("trip Rating Out of 5 Stars")) {
                HStack(spacing: 3) {
                    ForEach(1...(myFunc()), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            Section(header: Text("trip notes")) {
                Text(trip.notes ?? "")
            }
            Section(header: Text("trip start date")) {
                Text(trip.startDate ?? "")
            }
            Section(header: Text("trip end date")) {
                Text(trip.endDate ?? "")
            }
            Section(header: Text("Show trip Photo Location on Map")) {
                NavigationLink(destination: photoLocationOnMap) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Show trip Photo Location on Map")
                            .font(.system(size: 16))
                    }
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
            }
        }   // End of Form
            .navigationBarTitle(Text(trip.title ?? ""), displayMode: .inline)
            .font(.system(size: 14))
    } // body
    
    var tripCost: Text {
            let costOfTrip = trip.cost!.doubleValue
           
            // Add thousand separators to trip cost
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.groupingSize = 3
           
            let tripCostString = "$" + numberFormatter.string(from: costOfTrip as NSNumber)!
            return Text(tripCostString)
        }
   
    var photoLocationOnMap: some View {
        //let lat = trip.Photo?.latitude!.doubleValue
        //let long = trip.Photo?.longitude?.doubleValue
        return AnyView(MapView(mapType: MKMapType.standard, latitude: (latfunc()),
                               longitude: (longfunc()), delta: 15.0, deltaUnit: "degrees",
                               annotationTitle: "" , annotationSubtitle: "")
            .navigationBarTitle(Text(trip.title ?? ""), displayMode: .inline)
            .edgesIgnoringSafeArea(.all) )
    }
    
    func myFunc() -> Int{
        
        var rating = trip.rating!.doubleValue
                return Int(rating)
    }
    
    func latfunc() -> Double {
        var lati = trip.photo!.latitude!.doubleValue ?? 0.0
        return lati
    }
    
    func longfunc() -> Double {
        var longi = trip.photo!.longitude!.doubleValue ?? 0.0
        return longi
    }
}

