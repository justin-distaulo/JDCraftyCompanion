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
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Settings")
                    .foregroundColor(Color.jdText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 24)
            Spacer().frame(maxHeight: 60)
            HStack {
                Text("Some setting 1:")
                    .foregroundColor(Color.jdText)
                    .font(.body)
                    .fontWeight(.bold)
            }
            HStack {
                Text("Some setting 2:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
            }
            HStack {
                Text("Some setting 3:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }
}
