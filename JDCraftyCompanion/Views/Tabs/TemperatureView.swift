//
//  TemperatureView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-26.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI

struct TemperatureView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Temperature Control")
                    .foregroundColor(Color.jdText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 24)
            Spacer().frame(maxHeight: 60)
            HStack {
                Text("Current temperature:")
                    .foregroundColor(Color.jdText)
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.currentTemperature))ºC")
                    .foregroundColor(Color.jdText)
            }
            HStack {
                Text("Target temperature:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.targetTemperature))ºC")
                    .foregroundColor(Color.jdText)
            }
            HStack {
                Text("Booster temperature:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.boosterTargetTemperature))ºC")
                    .foregroundColor(Color.jdText)
            }
            Spacer()
        }
    }
}
