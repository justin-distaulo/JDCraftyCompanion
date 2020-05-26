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
    
    var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Temperature Control")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 24)
            Spacer().frame(maxHeight: 60)
            HStack {
                Text("Current temperature:")
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.currentTemperature))ºC")
            }
            HStack {
                Text("Target temperature:")
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.targetTemperature))ºC")
            }
            HStack {
                Text("Booster temperature:")
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.boosterTargetTemperature))ºC")
            }
            Spacer()
        }
    }
    
    func tabItem() -> some View {
        return self.tabItem {
            VStack {
                Image(systemName: "thermometer")
                Text("Temperature")
            }
        }
    }
    
    // TODO: Figure out the proper way to do this
    func padding() -> some View {
        return self.padding(.horizontal, 24)
    }
}
