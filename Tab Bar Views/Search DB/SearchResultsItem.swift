//
//  SearchResultsItem.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
import CoreData


struct SearchResultsItem: View {
    let trip: Trip
    
    
    var body: some View {
        HStack {
            // This public function is given in UtilityFunctions.swift
            photoImageFromBinaryData(binaryData: trip.photo!.tripPhoto!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0)
                .padding()
           
            VStack(alignment: .leading) {
                
                Text(trip.title ?? "")
                HStack(spacing: 3) {
                    ForEach(1...(myFunc()), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    Text("From:")
                Text(trip.startDate ?? "")
                }
                HStack {
                    Text("To:")
                Text(trip.endDate ?? "")
                }

            }
            .font(.system(size: 14))
        }
    }
    func myFunc() -> Int{
        
        var rating = trip.rating!.doubleValue
                return Int(rating)
    }
}
 
