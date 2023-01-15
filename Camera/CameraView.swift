//
//  ContentView.swift
//  Camera
//
//  Created by Jack Finnis on 16/09/2022.
//

import SwiftUI
import AVKit

struct CameraView: View {
    @State var angle = Double.zero
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PreviewView()
                .rotation3DEffect(.degrees(angle), axis: (0, 1, 0))
            
            FlipButton(angle: $angle)
        }
        .frame(idealWidth: .infinity, idealHeight: .infinity)
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
                .padding(10)
                .font(.title)
                .background(Color.accentColor)
                .clipShape(Circle())
                .rotation3DEffect(.degrees(angle), axis: (0, 1, 0))
        }
        .buttonStyle(.plain)
        .padding()
    }
}

struct FlipButton_Previews: PreviewProvider {
    static var previews: some View {
        FlipButton(angle: .constant(0))
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
