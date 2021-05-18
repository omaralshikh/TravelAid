//
//  WeatherStruct.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI

struct WeatherStruct: Identifiable, Hashable, Codable {
   
    
    var id: UUID
    var forecast: [ForecastStruct]
    var name: String
    var latitude: Double
    var longitude: Double
    var country: String
    
    
    
}
