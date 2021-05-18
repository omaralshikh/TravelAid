//
//  WeatherItem.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI

struct WeatherItem: View {
    let wthr: ForecastStruct
    
    var body: some View {
        HStack {
            //https://openweathermap.org/img/wn/10n@2x.png
            // Public function getImageFromUrl is given in UtilityFunctions.swift
            getImageFromUrl(url: "https://openweathermap.org/img/wn/\(wthr.icon)@2x.png", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128.0, height: 72.0)
           
            VStack(alignment: .leading) {
                Text(wthr.dt_txt)
                HStack {
                    Text(wthr.description)
                    
                }
                HStack {
                    Text("Humidity " + wthr.humidity.description + "%")
                    
                }
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
           
        }   // End of HStack
    }
    
}
