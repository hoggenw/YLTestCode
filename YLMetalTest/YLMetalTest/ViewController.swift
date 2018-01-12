//
//  ViewController.swift
//  YLMetalTest
//
//  Created by 王留根 on 2018/1/4.
//  Copyright © 2018年 王留根. All rights reserved.
//

import UIKit
import Metal
import QuartzCore
import YLSwiftScan

class ViewController: UIViewController {

    let manager = YLScanViewManager.shareManager()
    var metalDevice: MTLDevice! = nil;
    var metalLayer: CAMetalLayer! = nil; //真机
    var commandQueue: MTLCommandQueue! = nil;
    var piperlineStateDescriptor: MTLRenderPipelineDescriptor! = nil;
    var piperlineState: MTLRenderPipelineState! = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIButton()
        button1.backgroundColor = UIColor.brown
        button1.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 - 100, width: 60, height: 50)
        button1.setTitle("生成", for: .normal)
        button1.addTarget(self, action: #selector(creatSelfQRcODE), for: .touchUpInside)
        self.view.addSubview(button1)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testMetal()  {
        metalDevice = MTLCreateSystemDefaultDevice();
        guard metalDevice != nil else {
            print("Metal is not supported on this device");
            return
        }
        metalLayer = CAMetalLayer();
        metalLayer.device = metalDevice;
        metalLayer.pixelFormat = .bgra8Unorm;
        metalLayer.framebufferOnly = true;
        metalLayer.frame = self.view.bounds;
        self.view.layer.addSublayer(metalLayer);
    }
    
    //
    func initPipline() {
        commandQueue = metalDevice.makeCommandQueue();
        commandQueue.label = "main metal command queue";
        let defaultLibrary = metalDevice.makeDefaultLibrary()!;
        let fragmentProgram = defaultLibrary.makeFunction(name: "passThroughFragment")!;
        let vertexProgram = defaultLibrary.makeFunction(name: "passThroughVertex")!;
        
        
        self.piperlineStateDescriptor = MTLRenderPipelineDescriptor();
        piperlineStateDescriptor.vertexFunction = vertexProgram;
        piperlineStateDescriptor.fragmentFunction = fragmentProgram;
        piperlineStateDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat;
        
        do {
            try piperlineState = metalDevice.makeRenderPipelineState(descriptor: piperlineStateDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)");
        }
    }
    
    func render(qrcodeTexture: MTLTexture) {
        guard let drawable = metalLayer.nextDrawable() else {
            return;
        }
        //使用renderPassDescriptor来描述本次渲染的渲染目标和如何清空缓冲区
        let renderPassDescriptor = MTLRenderPassDescriptor.init();
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        
        let commandBuffer = commandQueue.makeCommandBuffer()!;
        commandBuffer.label = "Frame command buffer";
        
        //配合pipelineState获得一个用作绘图的对象renderEncoder
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!;
        renderEncoder.label = "render encoder";
        renderEncoder.pushDebugGroup("being draw");
        renderEncoder.setRenderPipelineState(piperlineState);
        
        //draw方法中使用该对象进行具体内容的绘制
        self.draw(renderEncoder: renderEncoder, qrcodeTexture: qrcodeTexture);
        renderEncoder.popDebugGroup();
        renderEncoder.endEncoding();
        
        //使用commandBuffer的present和commit把绘制指令递交给GPU
        commandBuffer.present(drawable);
        commandBuffer.commit();
        
    }
    
    func draw(renderEncoder: MTLRenderCommandEncoder, qrcodeTexture: MTLTexture) {
        let squareData: [Float] = [
            -1,   1,    0.0, 0, 0,
            -1,   -1,   0.0, 0, 1,
            1,    -1,   0.0, 1, 1,
            1,    -1,   0.0, 1, 1,
            1,    1,    0.0, 1, 0,
            -1,   1,    0.0, 0, 0
        ];
        let vertexBufferSize = MemoryLayout.size(ofValue: squareData[0]) * squareData.count
        let vertexBuffer = metalDevice.makeBuffer(bytes: squareData, length: vertexBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentTexture(qrcodeTexture, index: 0)
        
        let colors: [Float] = [
            0x2a / 255.0, 0x9c / 255.0, 0x1f / 255.0,
            0xe6 / 255.0, 0xcd / 255.0, 0x27 / 255.0,
            0xe6 / 255.0, 0x27 / 255.0, 0x57 / 255.0
        ]
        let colorsBufferSize = MemoryLayout.size(ofValue: colors[0]) * colors.count
        let colorsBuffer = metalDevice.makeBuffer(bytes: colors, length: colorsBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        renderEncoder.setFragmentBuffer(colorsBuffer, offset: 0, index: 0)
        
        let uniform: [Int] = [colors.count / 3]
        let uniformBufferSize = MemoryLayout.size(ofValue: colors[0]) * uniform.count
        let uniformBuffer = metalDevice.makeBuffer(bytes: uniform, length: uniformBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        renderEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        
    }
    
    @objc func creatSelfQRcODE() {
        let codeView = manager.produceQRcodeView(frame: CGRect(x: (self.view.bounds.size.width - 200)/2, y: self.view.bounds.size.height/2, width: 200, height: 200), logoIconName: "device_scan",codeMessage: "wlg's test Message")
        self.view.addSubview(codeView)
        
        
    }

}
























































