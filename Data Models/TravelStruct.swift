//
//  TravelStruct.swift
//  TravelAid
//
//  Created by Omar on 10/24/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData


struct Travel: Decodable {
    
   
    var title: String
    var cost: Double
    var rating: Int
    var startDate: String
    var endDate: String
    var notes: String
    var photoFilename: String
    var photoDateTime: String
    var photoLatitude: Double
    var photoLongitude: Double
}
