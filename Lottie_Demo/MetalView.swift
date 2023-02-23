//
//  MetalView.swift
//  Lottie_Demo
//
//  Created by 김태윤 on 2023/02/23.
//

import Foundation
import SwiftUI
import MetalKit
struct MetalView: UIViewRepresentable{
    typealias UIViewType = MTKView
    func makeCoordinator() -> Renderer{ //우리가 사용할 코디네이터
        let device = MTLCreateSystemDefaultDevice()!
        return Renderer(device: device,view:MTKView())
    }
    func makeUIView(context: Context) -> MTKView {
        return context.coordinator.view
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {}
    
}

final class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let view: MTKView
    private var renderPipelineState: MTLRenderPipelineState!
    private var vertexBuffer: MTLBuffer!

    init(device: MTLDevice, view: MTKView) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        self.view = view

        super.init()
        view.layer.isOpaque = false // 배경을 투명하게 만든다!!!
        view.device = device
        view.delegate = self
        view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)

        makePipeline()
        makeResources()
    }

    func makePipeline() {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Unable to create default Metal library")
        }

        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        
        renderPipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")!
        renderPipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")!

        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            fatalError("Error while creating render pipeline state: \(error)")
        }
    }

    func makeResources() {
        var positions = [
            SIMD2<Float>(-0.8,  0.4),
            SIMD2<Float>( 0.4, -0.8),
            SIMD2<Float>( 0.8,  0.8)
        ]
        vertexBuffer = device.makeBuffer(bytes: &positions,
                                         length: MemoryLayout<SIMD2<Float>>.stride * positions.count,
                                         options: .storageModeShared)
    }

    // MARK: - MTKViewDelegate

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }

    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderCommandEncoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
}
