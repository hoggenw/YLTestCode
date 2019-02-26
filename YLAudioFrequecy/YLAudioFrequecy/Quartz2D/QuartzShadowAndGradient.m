//
//  QuartzShadowAndGradient.m
//  YLAudioFrequecy
//
//  Created by hoggen on 2017/6/18.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "QuartzShadowAndGradient.h"

@implementation QuartzShadowAndGradient

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//渐变
/*
 渐变无非就是从一种颜色逐渐变换到另一种颜色，quart提供了两种渐变模型。
 axial gradient，线性渐变，使用的时候设置好两个顶点的颜色（也可以设置中间过渡色）
 例如
 只设置两个颜色，和顶点
 radial gradient
 这种模式的渐变允许，一个圆到另一个圆的渐变
 通过这两种渐变的嵌套使用，Quartz 2D能够绘制出非常漂亮的图形
 */

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGColorSpaceRef device = CGColorSpaceCreateDeviceRGB();
//    size_t num_of_loaction = 2;
//    CGFloat loactions[2] = {0.0,1.0};
//    CGFloat components[8] = {1.0, 0.0, 0.0, 1.0,  // 红色
//        0.0, 1.0, 0.0, 1.0};//绿色
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(device, components, loactions, num_of_loaction);
//    CGPoint startpoint = CGPointMake(0, 0);
//    CGPoint endPoint = CGPointMake(100, 100);
//    CGContextDrawLinearGradient(context, gradient, startpoint, endPoint, 0);
//    CGColorSpaceRelease(device);
//    CGGradientRelease(gradient);
//    CGContextRelease(context);
//}

//我们绘制一个RadialGradient，

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef device = CGColorSpaceCreateDeviceRGB();
    size_t num_of_loaction = 2;
    CGFloat loactions[2] = {0.0,1.0};
    CGFloat components[8] = {1.0, 0.0, 0.0, 1.0,  // 红色
        0.0, 1.0, 0.0, 1.0};//绿色
    CGGradientRef gradient = CGGradientCreateWithColorComponents(device, components, loactions, num_of_loaction);
    CGPoint startpoint = CGPointMake(30, 30);
    CGPoint endPoint = CGPointMake(50, 50);
    CGFloat startRadius = 0.0;
    CGFloat endRadius = 40.0;
    CGContextDrawRadialGradient(context, gradient, startpoint, startRadius, endPoint, endRadius, 0);
    CGColorSpaceRelease(device);
    CGGradientRelease(gradient);
    CGContextRelease(context);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.opaque = NO;
    }
    return self;
}

//CGShading绘制
/**
 使用CGShadingCreateAxial或者CGShadingCreateRadial来创建对象，传入的参数如下
 
 Color Space，处理的颜色域，在iOS通畅就是device RGB
 开始的点和结束的点
 对于 radial gradient要传入开始和结束的半径
 CGFunction 对象来计算每个点的显示值
 一个bool值，来确定是否要填充没有被渐变覆盖的区域
 
 这里面最复杂的就是创建一个CGFunction对象，使用CGFunctionCreate来创建，我们线看看这个函数
 CGFunctionRef _Nullable CGFunctionCreate (
 void * _Nullable info,
 size_t domainDimension,
 const CGFloat * _Nullable domain,
 size_t rangeDimension,
 const CGFloat * _Nullable range,
 const CGFunctionCallbacks * _Nullable callbacks
 );
 */

//阴影
/**
 x off-set 决定阴影沿着x的偏移量
 y off-set 决定阴影沿着y的偏移量
 blur value 决定了阴影的边缘区域是不是模糊的
 Shadow也是绘制状态相关的，意味着如果仅仅要绘制一个subpath的shadow，要注意save和restore状态。
 CGContextSetShadow
 CGContextSetShadowWithColor//位移区别是设置了阴影颜色
 context 绘制画板
 offset 阴影偏移量，参考context的坐标系
 blur 非负数，决定阴影的模糊程度
 */


//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddArc(context, 40, 40, 20, 0, M_2_PI, 0);
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineWidth(context, 3.0);
//    CGContextSetShadow(context, CGSizeMake(4,4), 1.0);
//    CGContextStrokePath(context);
//    CGContextRelease(context);
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.opaque = NO;
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.layer.borderWidth = 1.0;
//    }
//    
//    return self;
//}
@end



































