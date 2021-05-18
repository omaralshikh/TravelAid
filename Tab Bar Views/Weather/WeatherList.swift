//
//  WeatherList.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI

struct WeatherList: View {
    let weather: WeatherStruct
    
    var body: some View {
        NavigationView {
            List {
                ForEach(weather.forecast)
                { item in
                    NavigationLink(destination: WeatherDetails(wthr: item, name: weather.name, lat: weather.latitude, long: weather.longitude, country: weather.country))
                    {
                        WeatherItem(wthr: item)
                    }
                }
               
            }   // End of List
            .navigationBarTitle(Text("Weather Forecast Every 3 Hours for 5 Days"), displayMode: .inline)
           
           
        }   // End of NavigationView
            .customNavigationViewStyle()  // Given in NavigationStyle.swift
    }
}

