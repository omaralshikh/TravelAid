//
//  ContentView.swift
//  TravelAid
//
//  Created by Omar on 10/24/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
         
           MyTripList()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("My Trips")
                }
             SearchDatabase()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search DB")
                }
            
            Weather()
                .tabItem {
                    Image(systemName: "cloud.sun")
                    Text("Weather")
                }
 
            
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData())
    }
}
 
