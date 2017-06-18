//
//  QuartzView.m
//  YLAudioFrequecy
//
//  Created by hoggen on 2017/6/18.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "QuartzView.h"

@implementation QuartzView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


/**
 void CGContextAddCurveToPoint (
 CGContextRef _Nullable c,
 CGFloat cp1x,
 CGFloat cp1y,
 CGFloat cp2x,
 CGFloat cp2y,
 CGFloat x,
 CGFloat y
 );
 c context
 cp1x,cp1y 第一个控制点
 cp2x,cp2y 第二个控制点
 x,y 结束点
 */
//单曲线
/**
 void CGContextAddQuadCurveToPoint (
 CGContextRef _Nullable c,
 CGFloat cpx,
 CGFloat cpy,
 CGFloat x,
 CGFloat y
 );
 c context
 cpx,cpy控制点
 x,y结束点
 */

//椭圆与曲线
- (void)drawRect:(CGRect)rect {
    //获得当前context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置颜色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    //为了颜色更好区分，对矩形描边
    CGContextFillRect(context, rect);
    CGContextStrokeRect(context, rect);
    
    
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(10, 10, 40, 20));
    CGContextAddRect(context, CGRectMake(10, 10, 40, 20));
    
    CGContextMoveToPoint(context, 0, 50);
    CGContextAddCurveToPoint(context, 25, 0, 75, 100, 100, 50);
    CGContextMoveToPoint(context, 0, 50);
    CGContextAddQuadCurveToPoint(context, 50, 0, 100, 50);
    
    CGContextStrokePath(context);
    
    CGContextRelease(context);
    
}



/*
 void CGContextAddArc (
 CGContextRef _Nullable c,
 CGFloat x,
 CGFloat y,
 CGFloat radius,
 CGFloat startAngle,
 CGFloat endAngle,
 int clockwise
 );
 c，context不用剁手
 x,y指定坐标原点
 radius，指定半径长度
 startAngle/endAngle,指定某一段弧度
 clockwise，1表示顺时针，0表示逆时针
 */

/**
 void CGContextAddArcToPoint (
 CGContextRef _Nullable c,
 CGFloat x1,
 CGFloat y1,
 CGFloat x2,
 CGFloat y2,
 CGFloat radius
 );
 c context
 x1,y1和当前点(x0,y0)决定了第一条切线（x0,y0）->(x1,y1)
 x2,y2和(x1,y1)决定了第二条切线
 radius,想切的半径。
 
 */
//虚线
//- (void)drawRect:(CGRect)rect {
//    //获得当前context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //设置颜色
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    //为了颜色更好区分，对矩形描边
//    CGContextFillRect(context, rect);
//    CGContextStrokeRect(context, rect);
//    //实际line和point的代码
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);// 设置描边颜色
//    CGContextSetLineWidth(context, 1.0);//线的宽度
//    CGContextSetLineCap(context, kCGLineCapRound);//线的顶端
//    CGContextSetLineJoin(context, kCGLineJoinRound);//线相交的模式
//
//    CGFloat lengths[] = {2};
//    /*
//     c 绘制的context，这个不用多说
//     phase，第一个虚线段从哪里开始，例如传入3，则从第三个单位开始
//     lengths,一个C数组，表示绘制部分和空白部分的分配。例如传入[2,2],则绘制2个单位，然后空白两个单位，以此重复
//     count lengths的数量
//     */
//    CGContextSetLineDash(context, 1, lengths, 1);
//    CGContextMoveToPoint(context, 10, 10);
//    CGContextAddLineToPoint(context, 40, 40);
//    CGContextAddLineToPoint(context, 10, 80);
//
//    CGContextAddArc(context, 50, 50, 25, M_PI_2, M_PI, 1);
//
//    CGContextMoveToPoint(context, 100, 50);
//    CGContextAddArcToPoint(context, 100, 0, 50, 0, 50);
//
//    CGContextStrokePath(context);
//
//
//    CGContextRelease(context);
//
//}



//实线
//- (void)drawRect:(CGRect)rect {
//     //获得当前context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //设置颜色
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    //为了颜色更好区分，对矩形描边
//    CGContextFillRect(context, rect);
//    CGContextStrokeRect(context, rect);
//    //实际line和point的代码
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);// 设置描边颜色
//    CGContextSetLineWidth(context, 4.0);//线的宽度
//    CGContextSetLineCap(context, kCGLineCapRound);//线的顶端
//    CGContextSetLineJoin(context, kCGLineJoinRound);//线相交的模式
//
//    CGContextMoveToPoint(context, 10, 10);
//    CGContextAddLineToPoint(context, 40, 40);
//    CGContextAddLineToPoint(context, 10, 80);
//    CGContextStrokePath(context);
//
//}




/*
 CGPathRef 路径类型，用来绘制路径（注意带有ref后缀的一般都是绘制的画板）
 CGImageRef，绘制bitmap
 CGLayerRef，绘制layer，layer可复用，可离屏渲染
 CGPatternRef，重复绘制
 CGShadingRef和CGGradientRef，绘制渐变（例如颜色渐变）
 CGFunctionRef，定义回调函数，CGShadingRef和CGGradientRef的辅助类型
 CGColorRef and CGColorSpaceRef，定义如何处理颜色
 CGFontRef，绘制文字
 其他类型（pdf这个系列不讲解，所以不会涉及）
 */

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    CGContextFillRect(context, rect);
//    CGRect testRect = CGRectMake(10, 10, 20, 20);
//    CGContextAddRect(context, testRect);
//    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
//    CGContextFillRect(context, testRect);
//    NSString * toDraw = @"Leo";
//    [toDraw drawAtPoint:CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor greenColor]}];
//
//    CGContextSaveGState(context);
//    //这行代码把坐标系移动到右下角
//    CGContextTranslateCTM(context,rect.size.width,rect.size.height);
//    //接着把坐标系逆时针旋转180度
//    CGContextRotateCTM(context, M_PI);
//    NSString * heart = @"❤️";
//    [heart drawAtPoint:CGPointMake(0, 0) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//    CGContextRestoreGState(context);
//    CGContextRelease(context);
//
//}




@end






















