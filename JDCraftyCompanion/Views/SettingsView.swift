//
//  SettingsView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-26.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentation
    
    var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 24)
            Spacer().frame(maxHeight: 60)
            HStack {
                Text("Some setting 1:")
                    .font(.body)
                    .fontWeight(.bold)
            }
            HStack {
                Text("Some setting 2:")
                    .fontWeight(.bold)
            }
            HStack {
                Text("Some setting 3:")
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }
    
    func tabItem() -> some View {
        return self.tabItem {
            VStack {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
    }
    
    func padding() -> some View {
        return self.padding(.horizontal, 24)
    }
}
