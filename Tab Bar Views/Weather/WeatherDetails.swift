//
//  WeatherDetails.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
import MapKit

struct WeatherDetails: View {
    let wthr: ForecastStruct
    let name : String
    let lat: Double
    let long: Double
    let country : String
    
    var body: some View {
        NavigationView {
        Form {
                Section(header: Text("Forecast location")) {
                    Text(name + ", " + country)
                    
                }
            
            Section(header: Text("show location map")) {
            NavigationLink(destination: placeLocationOnMap) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .imageScale(.medium)
                        .font(Font.title.weight(.regular))
                    Text("Show Location on Map")
                        .font(.system(size: 16))
                }
                .foregroundColor(.blue)
            }
            .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
        }
            
            Section(header: Text("date and time of 3-hour forecast")) {
                Text(wthr.dt_txt)
            }
            
            Section(header: Text("weather icon")) {
                getImageFromUrl(url: "https://openweathermap.org/img/wn/\(wthr.icon)@2x.png", defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128.0, height: 72.0)
            }
            
            
            Section(header: Text("Description")) {
                Text(wthr.description)
            }
            
            Section(header: Text("Humidity Percentage")) {
                Text(wthr.humidity.description + "%")
            }
            
            Section(header: Text("minimum Temperature")) {
                Text(wthr.temp_min.description + "˚" + " F")
            }
            
            Section(header: Text("maximum Temperature")) {
                Text(wthr.temp_max.description + "˚" + " F")
            }
        } // form
        .navigationBarTitle(Text("3-Hour Forecast"), displayMode: .inline)
        .font(.system(size: 14))
        } // nav
        .navigationViewStyle(StackNavigationViewStyle())
    }// body
    
    var placeLocationOnMap: some View {

        return AnyView( MapView(mapType: MKMapType.standard, latitude: lat, longitude: long, delta: 10.0, deltaUnit: "degrees", annotationTitle: name, annotationSubtitle: country)
                .navigationBarTitle(Text("\(name) Map"), displayMode: .inline)
                .edgesIgnoringSafeArea(.all) )
    }
}
