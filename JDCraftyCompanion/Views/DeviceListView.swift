//
//  DeviceListView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-22.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI

struct DeviceListView: View {
    
    @Environment(\.presentationMode) var presentation
    
    var viewModel: MainViewModel

    var body: some View {
        VStack {
            LottieView(name: "hamster").frame(width: 100, height: 100)
            Spacer().frame(maxHeight: 16)
            Text(viewModel.loadingText)
            Text("Found Devices:")
            ForEach(self.viewModel.devices, id: \.identifier) { device in
                Text(device.name).onTapGesture {
                    self.viewModel.connect(toDevice: device)
                }
            }
        }
    }
}
