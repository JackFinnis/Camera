//
//  CameraApp.swift
//  Camera
//
//  Created by Jack Finnis on 16/09/2022.
//

import SwiftUI
import AVKit

@main
struct CameraApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct RootView: View {
    @State var angle = Double.zero
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CameraView()
                .rotation3DEffect(.degrees(angle), axis: (0, 1, 0))
            FlipButton(angle: $angle)
        }
        .ignoresSafeArea()
    }
}

struct FlipButton: View {
    @Binding var angle: Double
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 1)) {
                angle += 180
            }
        } label: {
            Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                .frame(width: 50, height: 50)
                .font(.title)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(Circle())
                .rotation3DEffect(.degrees(angle), axis: (0, 1, 0))
        }
        .buttonStyle(.plain)
        .padding()
    }
}

struct CameraView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else { return view }
        
        let session = AVCaptureSession()
        session.addInput(input)
        session.startRunning()
        
        let layer = AVCaptureVideoPreviewLayer()
        view.layer = layer
        layer.session = session
        
        return view
    }
    
    func updateNSView(_ view: NSView, context: Context) {}
}
