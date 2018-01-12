//
//  UIImageView+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import Kingfisher
import Metal
import QuartzCore


public extension UIImageView
{
    // MARK: - Initialization Function
    
    public convenience init(imageName: String?, mode: UIViewContentMode = .scaleAspectFill, clipsToBounds: Bool = true) {
        self.init()
        self.contentMode = mode
        self.clipsToBounds = clipsToBounds
        if nil != imageName {
            self.image = UIImage.init(named: imageName!)
        }
    }
    
    
    // Remark: 系统 public init(image: UIImage?)
    public convenience init(placeHolder: UIImage?, mode: UIViewContentMode = .scaleAspectFill, clipsToBounds: Bool = true) {
        self.init()
        self.image = placeHolder
        self.contentMode = mode
        self.clipsToBounds = clipsToBounds
    }
    
    
    @discardableResult
    func setImage(with resource: Resource?,
                  placeholder: Image? = nil,
                  options: KingfisherOptionsInfo? = nil,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
        
        if resource == nil {
            self.image = placeholder
            return self.kf.setImage(with: nil)
        }
        return self.kf.setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
    
    public func beiginRendering(){
        // 有七个步骤来设置metal：
        // 1.创建一个MTLDevice
        let device: MTLDevice! = MTLCreateSystemDefaultDevice();
        ////2.创建一个CAMetalLayer
        let metalLayer: CAMetalLayer! = CAMetalLayer();
        metalLayer.device = device;
        metalLayer.pixelFormat = .bgra8Unorm;
        metalLayer.framebufferOnly = true
        metalLayer.frame = self.layer.frame;
        self.layer.addSublayer(metalLayer);
        //3.创建一个Vertex Buffer
        //var vertexBuffer: MTLBuffer! = nil;
        let squareData: [Float] = [
            -1,   1,    0.0, 0, 0,
            -1,   -1,   0.0, 0, 1,
            1,    -1,   0.0, 1, 1,
            1,    -1,   0.0, 1, 1,
            1,    1,    0.0, 1, 0,
            -1,   1,    0.0, 0, 0
        ];
        let vertexBufferSize = MemoryLayout.size(ofValue: squareData[0]) * squareData.count
        let vertexBuffer = device.makeBuffer(bytes: squareData, length: vertexBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        
        //4.创建一个Vertex Shader
        //5.创建一个Fragment Shader
        
        //6.创建一个Render Pipeline
        
        let defaultLibrary = device.newDefaultLibrary()!;
        let fragmentProgram = defaultLibrary.makeFunction(name: "passThroughFragment")!;
        let vertexProgram = defaultLibrary.makeFunction(name: "passThroughVertex")!;
        
        //设置你的render pipeline。它包含你想要使用的shaders、颜色附件（color attachment）的像素格式(pixel format)。
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor();
        pipelineStateDescriptor.vertexFunction = vertexProgram;
        pipelineStateDescriptor.fragmentFunction = fragmentProgram;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm;
        
        
        var piplineState: MTLRenderPipelineState! = nil;
        //把这个pipeline 配置编译到一个pipeline 状态(state)中，让它使用起来有效率。
        do {
            try piplineState = device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)");
        }
        
        
        
        
        //7.创建一个Command Queue
        var commandQueue: MTLCommandQueue! = nil;
        commandQueue = device.makeCommandQueue();
        commandQueue.label = "main metal command queue";
        
        //渲染：它将在五个步骤中被完成：
        //1.创建一个Display link。
        //var timer: CADisplayLink! = nil
        //2.创建一个Render Pass Descriptor
        guard let drawable = metalLayer.nextDrawable() else {
            return;
        }
        //使用renderPassDescriptor来描述本次渲染的渲染目标和如何清空缓冲区
        let renderPassDescriptor = MTLRenderPassDescriptor.init();
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        
        //3.创建一个Command Buffer
        let commandBuffer = commandQueue.makeCommandBuffer();
        commandBuffer.label = "Frame command buffer";
        
        
        //4.创建一个Render Command Encoder
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor);
        renderEncoder.setRenderPipelineState(piplineState);
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0);
        renderEncoder.setFragmentTexture(createQRCodeTexture(device: device), at: 0)
        
        renderEncoder.label = "render encoder";
        
        
        let colors: [Float] = [
            0x2a / 255.0, 0x9c / 255.0, 0x1f / 255.0,
            0xe6 / 255.0, 0xcd / 255.0, 0x27 / 255.0,
            0xe6 / 255.0, 0x27 / 255.0, 0x57 / 255.0
        ]
        let colorsBufferSize = MemoryLayout.size(ofValue: colors[0]) * colors.count
        let colorsBuffer = device.makeBuffer(bytes: colors, length: colorsBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        renderEncoder.setFragmentBuffer(colorsBuffer, offset: 0, at: 0)
        
        let uniform: [Int] = [colors.count / 3]
        let uniformBufferSize = MemoryLayout.size(ofValue: colors[0]) * uniform.count
        let uniformBuffer = device.makeBuffer(bytes: uniform, length: uniformBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        renderEncoder.setFragmentBuffer(uniformBuffer, offset: 0, at: 1)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        
        renderEncoder.pushDebugGroup("being draw");
        renderEncoder.endEncoding();
        
        //5.提交你Command Buffer的内容。
        commandBuffer.present(drawable);
        commandBuffer.commit();
        
    }
    
    //使用UIImage类型的二维码图片生成Metal纹理。
    

    private func createQRCodeTexture(device: MTLDevice) -> MTLTexture? {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let width:Int = Int(self.image!.size.width)
        let height:Int = Int(self.image!.size.height)
        let imageData = UnsafeMutableRawPointer.allocate(bytes: Int(width * height * bytesPerPixel), alignedTo: 8)
        //将图片数据解压为RGBA格式的纯字节流，然后通过Metal的API创建纹理。
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let imageContext = CGContext.init(data: imageData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: width * bytesPerPixel, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Big.rawValue )
        UIGraphicsPushContext(imageContext!)
        imageContext?.translateBy(x: 0, y: CGFloat(height))
        imageContext?.scaleBy(x: 1, y: -1)
        self.image!.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        descriptor.usage = .shaderRead
        let texture = device.makeTexture(descriptor: descriptor)
        texture.replace(region: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0, withBytes: imageData, bytesPerRow: width * bytesPerPixel)
        return texture
    }
}
