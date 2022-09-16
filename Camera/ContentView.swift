//
//  ContentView.swift
//  Camera
//
//  Created by Jack Finnis on 16/09/2022.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var appeared = false
    
    let size = NSScreen.main?.frame.size ?? CGSize(width: 1000, height: 1000)
    
    var body: some View {
        PreviewView()
            .edgesIgnoringSafeArea(.all)
            .frame(width: appeared ? nil : size.width, height: appeared ? nil : size.height)
            .task { appeared = true }
    }
}

struct PreviewView: NSViewRepresentable {
    func makeNSView(context: Context) -> PreviewNSView {
        PreviewNSView()
    }

    func updateNSView(_ uiView: PreviewNSView, context: Context) {}
}

class PreviewNSView: NSView {
    var session: AVCaptureSession?

    init() {
        super.init(frame: .zero)
        
        session = AVCaptureSession()
        session?.beginConfiguration()

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session?.canAddInput(input) ?? false
        else { return }
        
        session?.addInput(input)
        session?.commitConfiguration()

        wantsLayer = true
        layer = AVCaptureVideoPreviewLayer()
        
        guard let layer = layer as? AVCaptureVideoPreviewLayer else { return }
        layer.session = session
        session?.startRunning()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
