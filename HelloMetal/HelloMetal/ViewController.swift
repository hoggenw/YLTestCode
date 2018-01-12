//
//  ViewController.swift
//  HelloMetal
//
//  Created by 王留根 on 2018/1/11.
//  Copyright © 2018年 hoggen. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class ViewController: UIViewController {
    
    
    // 有七个步骤来设置metal：
    // 1.创建一个MTLDevice
    var device: MTLDevice! = nil;
    ////2.创建一个CAMetalLayer
    var metalLayer: CAMetalLayer! = nil;
   //3.创建一个Vertex Buffer
    var vertexBuffer: MTLBuffer! = nil;
   //4.创建一个Vertex Shader
   //5.创建一个Fragment Shader
    //6.创建一个Render Pipeline
    var piplineState: MTLRenderPipelineState! = nil;
    var piperlineState: MTLRenderPipelineState! = nil;
    //7.创建一个Command Queue
    var commandQueue: MTLCommandQueue! = nil;
    
    
    //渲染：它将在五个步骤中被完成：
    //1.创建一个Display link。
    var timer: CADisplayLink! = nil
    //2.创建一个Render Pass Descriptor
    //3.创建一个Command Buffer
    //4.创建一个Render Command Encoder
    //5.提交你Command Buffer的内容。
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        device = MTLCreateSystemDefaultDevice();
        //创建了一个CAMetalLayer
        metalLayer = CAMetalLayer();
        //必须明确layer使用的MTLDevice
        metalLayer.device = device;
        //像素格式（pixel format）设置为BGRA8Unorm，它代表”8字节代表蓝色、绿色、红色和透明度，通过在0到1
        metalLayer.pixelFormat = .bgra8Unorm;
       // 设置framebufferOnly为true，来增强表现效率
        metalLayer.framebufferOnly = true;
        metalLayer.frame = view.layer.frame;
        view.layer.addSublayer(metalLayer);
        //在Metal里每一个东西都是三角形。在这个应用里，你只需要画一个三角形，不过即使是极其复杂的3D形状也能被解构为一系列的三角形。
        
        //这在CPU创建一个浮点数数组——你需要通过把它移动到一个叫MTLBuffer的东西，来发送这些数据到GPU。
        let vertexData:[Float] = [
            0.0, 1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0]
        //获取vertex data的字节大小。你通过把第一个元素的大小和数组元素个数相乘来得到。
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]);
        //在GPU创建一个新的buffer，从CPU里输送data。
        vertexBuffer =  device.makeBuffer(bytes: vertexData, length: dataSize, options: MTLResourceOptions(rawValue: 0)) // 2
        
        //=================================这部分内容在shader.metal之中=======================================
        //创建一个Vertex Shader
        //之前创建的顶点将成为你接下来写的一个叫vertext shader的小程序的输入。
        //一个vertex shader 是一个在GPU上运行的小程序，它由像c++的一门语言编写，那门语言叫做Metal Shading Language。
        // 一个vertex shader被每个顶点调用，它的工作是接受顶点的信息（如：位置和颜色、纹理坐标），返回一个潜在的修正位置（可能还有别的相关信息）
        //。点击File\New\File，选择iOS\Source\Metal File，然后点击Next。输入Shader.metal作为文件名上按回车，然后点击Create。
        //在Metal里，你能够在一个Metal文件里包含多个shaders。你也能把你的shader 分散在多个Metal文件中。Metal会从任意Metal文件中加载你项目包含的shaders。
        
        //=================================这部分内容在shader.metal之中=======================================
        
        //创建一个Render Pipeline
        //现在你已经创建了一个vertex shader和一个fragment shader，你需要组合它们（加上一些配置数据）到一个特殊的对象，它名叫render pipeline。
        //Metal一个很酷的地方是，渲染器（shaders）是预编译的，render pipeline 配置会在你第一次设置它的时候被编译，所以所有事情都极其高效。
        let defaultLibrary = device.makeDefaultLibrary()!;
        //获得的MTLibrary对象访问到你项目中的预编译shaders
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")!;
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")!;
        
        //设置你的render pipeline。它包含你想要使用的shaders、颜色附件（color attachment）的像素格式(pixel format)。
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor();
        pipelineStateDescriptor.vertexFunction = vertexProgram;
        pipelineStateDescriptor.fragmentFunction = fragmentProgram;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm;
        
        //把这个pipeline 配置编译到一个pipeline 状态(state)中，让它使用起来有效率。
        do {
            try piperlineState = device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)");
        }
        
        //你需要做的最终的一次性设置步骤，是创建一个MTLCommandQueue。
        // 把这个想象成是一个列表装载着你告诉GPU一次要执行的命令。
        commandQueue = device.makeCommandQueue();
        
        //=========================预设置的代码===================================
        
        
        //渲染 :理论上这个应用实际上不需要每帧渲染，因为三角形被绘制之后不会动。但是，大部分应用会有物体的移动，所以我们会那样做。同时也为将来的教程打下基础。
        //1）创建一个Display Link
        timer = CADisplayLink(target: self, selector: #selector(gameloop));
        timer.add(to: RunLoop.main, forMode: .defaultRunLoopMode);
        
        //2)创建一个Render Pass Descriptor
        //下一步是创建一个MTLRenderPassDescriptor，它能配置什么纹理会被渲染到、什么是clear color，以及其他的配置。
        
        //metal layer上调用nextDrawable() ，它会返回你需要绘制到屏幕上的纹理(texture)
        let drawable = metalLayer.nextDrawable()!;
        let renderPassDescriptor = MTLRenderPassDescriptor();
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
        //设置load action为clear，也就是说在绘制之前，把纹理清空
        renderPassDescriptor.colorAttachments[0].loadAction = .clear;
        //绘制的背景颜色设置为绿色。
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0);
        
        
        //3）创建一个Command Buffer
        //你可以把它想象为一系列这一帧想要执行的渲染命令。酷的是在你提交command buffer之前，没有事情会真正发生，这样给你对事物在何时发生有一个很好的控制。
        
        let commandBuffer = commandQueue.makeCommandBuffer()!;//command buffer包含一个或多个渲染指令（render commands）
        
        //4）创建一个渲染命令编码器(Render Command Encoder)
        //为了创建一个渲染命令（render command），你使用一个名叫render command encoder的对象。
        //指定你之前创建的pipeline和顶点
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!;
        renderEncoder.setRenderPipelineState(piperlineState);
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0);
        //让它基于vertex buffer画一系列的三角形。每个三角形由三个顶点组成，从vertex buffer 下标为0的顶点开始，总共有一个三角形。
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1);
        renderEncoder.endEncoding();
        
        //5）提交你的Command Buffer
        commandBuffer.present(drawable);
        commandBuffer.commit();
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func render() {
        // TODO
  
    }
    
    @objc func gameloop() {
        autoreleasepool {
            self.render()
        }
    }


}



































