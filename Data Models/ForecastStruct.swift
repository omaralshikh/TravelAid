//
//  ForecastStruct.swift
//  TravelAid
//
//  Created by Omar on 11/2/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI

struct ForecastStruct: Hashable, Codable, Identifiable {
    
    var id: UUID
    var icon: String
    var description: String
    var temp_min: Double
    var temp_max: Double
    var humidity: Int
    var dt_txt: String
}
