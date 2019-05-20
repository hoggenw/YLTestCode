
//
//  shader.metal
//  HelloMetal
//
//  Created by 王留根 on 2018/1/11.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
//函数必须至少返回顶点的最终位置——你通过指定float4（一个元素为4个浮点数的向量）。然后你给一个名字给vetex shader，以后你将用这个名字来访问这个vertex shader。
vertex float4 basic_vertex(                           // 所有的vertex shaders必须以关键字vertex开头。
                           const device packed_float3* vertex_array [[ buffer(0) ]], // 第一个参数是一个指向一个元素为packed_float3(一个向量包含3个浮点数)的数组的指针，如：每个顶点的位置。这个 [[ ... ]] 语法被用在声明那些能被用作特定额外信息的属性，像是资源位置，shader输入，内建变量。这里你把这个参数用 [[ buffer(0) ]] 标记，来指明这个参数将会被在你代码中你发送到你的vertex shader的第一块buffer data所遍历。
                           unsigned int vid [[ vertex_id ]]) {                 // vertex shader会接受一个名叫vertex_id的属性的特定参数，它意味着它会被vertex数组里特定的顶点所装入。
    return float4(vertex_array[vid], 1.0);              // 现在你基于vertex id来检索vertex数组中对应位置的vertex并把它返回。同时你把这个向量转换为一个float4类型，最后的value设置为1.0（简单的来说，这是3D数学要求的）。
}
/**
 完成我们的vertex shader后，另一个shader，它被每个在屏幕上的fragment(think pixel)调用，它就是fragment shader。
 
 fragment shader通过内插(interpolating)vertex shader的输出还获得自己的输入。比如：思考在三角形两个底顶点之间的fragment：
 
 
 fragment的输入值将会由50%的左下角顶点和50%的右下角顶点组成。
 
 fragment shader的工作是给每个fragment返回最后的颜色。为了简便，你将会把每个fragment返回白色。*/

//所有fragment shaders必须以fragment关键字开始。这个函数必须至少返回fragment的最终颜色——你通过指定half4（一个颜色的RGBA值）来完成这个任务。
//注意，half4比float4在内存上更有效率，因为，你写入了更少的GPU内存。
fragment half4 basic_fragment() { // 1
    return half4(1.0);              // 返回(1,1,1,1)的颜色，也就是白色。
}









































