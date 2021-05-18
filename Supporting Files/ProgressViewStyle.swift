//
//  ProgressView.swift
//  TravelAid
//
//  Created by Omar on 11/3/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
 
struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .shadow(color: Color(red: 0, green: 0, blue: 0.6),
                    radius: 4.0, x: 1.0, y: 2.0)
    }
}
 
