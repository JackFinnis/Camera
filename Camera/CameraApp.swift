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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                    guard let window = NSApplication.shared.windows.first,
                          let screen = NSScreen.main
                    else { return }
                    window.setFrame(screen.visibleFrame, display: true)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .commandsRemoved()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

struct RootView: View {
    @State var degrees: Double = 180
    @State var authorized: Bool = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    
    var body: some View {
        if authorized {
            ZStack(alignment: .bottomLeading) {
                CameraView()
                    .rotation3DEffect(.degrees(degrees), axis: (0, 1, 0))
                FlipButton(degrees: $degrees)
            }
            .ignoresSafeArea()
        } else {
            ProgressView()
                .task {
                    authorized = await AVCaptureDevice.requestAccess(for: .video)
                }
        }
    }
}

struct FlipButton: View {
    @Binding var degrees: Double
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 1)) {
                degrees += 180
            }
        } label: {
            Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                .frame(width: 50, height: 50)
                .font(.title)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(Circle())
                .rotation3DEffect(.degrees(degrees), axis: (0, 1, 0))
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
