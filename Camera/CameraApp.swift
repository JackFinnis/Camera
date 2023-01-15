//
//  CameraApp.swift
//  Camera
//
//  Created by Jack Finnis on 16/09/2022.
//

import SwiftUI

@main
struct CameraApp: App {
    var body: some Scene {
        WindowGroup {
            CameraView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}
