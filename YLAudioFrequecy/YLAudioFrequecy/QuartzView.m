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

/**Quartz默认采用设备无关的user space来进行绘图，当context（画板）建立之后，默认的坐标系原点以及方向也就确认了
 ，可以通过CTM（current transformation matrix）来修坐标系的原点。
 从数组图像处理的角度来说，就是对当前context state乘以一个状态矩阵。其中的矩阵运算开发者可以不了解。
 */

/**
Affine Transforms

可以通过以下方法先创建放射矩阵，然后然后再把放射矩阵映射到CTM

CGAffineTransform
CGAffineTransformTranslate
CGAffineTransformMakeRotation
CGAffineTransformRotate
CGAffineTransformMakeScale
CGAffineTransformScale
*/

//坐标位移，旋转，scale
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //保存状态，入栈
    CGContextSaveGState(context);
    
    
    //移动坐标系
    CGContextTranslateCTM(context, 10, 10);
    //旋转坐标系
    CGContextRotateCTM(context, M_PI_4);
    //scale 比例
    CGContextScaleCTM(context, 0.5, 1);
    CGContextAddRect(context, CGRectMake(10,10,40, 20));
    CGContextSetFillColorWithColor(context,[UIColor blueColor].CGColor);
    CGContextFillPath(context);
    //在复杂的绘图中，我们可能只是想对一个subpath进行旋转移动，缩放。这时候，状态堆栈就起到作用了。
    //推出栈顶部状态
    CGContextRestoreGState(context);
    
    //这里已经回到最开始的状态
    CGContextAddRect(context, CGRectMake(0, 0, 10, 10));
    CGContextFillPath(context);
    
    CGContextRelease(context);
    
    
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
    }
    return self;
}


//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        self.opaque = NO;
//    }
//    return self;
//}
//
////切割
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //很简单，在stroke/fill或者CGContextBeginPath/CGContextClosePath以后就新开启一个子路径
//    CGContextBeginPath(context);
//    CGContextAddArc(context, 50, 50, 20, 0, M_PI * 2, 1);
//    CGContextClosePath(context);
//    CGContextClip(context);
//    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    CGContextFillRect(context, rect);
//    //New Code
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//
//    CGContextMoveToPoint(context,10,10);
//    CGContextAddLineToPoint(context, 50, 50);
//    CGContextAddLineToPoint(context, 10, 90);
//
//    CGContextSetLineWidth(context, 10.0);
//    CGContextSetLineJoin(context, kCGLineJoinMiter);
//    CGContextSetMiterLimit(context,20.0);
//    CGContextStrokePath(context);
//
//    CGContextRelease(context);
//
//    /**
//     CGContextClip 按照nonzero winding number rule规则切割
//     CGContextEOClip 按照even-odd规则切割
//     CGContextClipToRect 切割到指定矩形
//     CGContextClipToRects 切割到指定矩形组
//     CGContextClipToMask 切割到mask
//     */
//}




//- (void)drawRect:(CGRect)rect {
//    //获得当前context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //设置颜色
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    //为了颜色更好区分，对矩形描边
//    CGContextFillRect(context, rect);
//    CGContextStrokeRect(context, rect);
//    CGContextMoveToPoint(context,10,10);
//    CGContextAddLineToPoint(context, 50, 50);
//    CGContextAddLineToPoint(context, 10, 90);
//    CGContextSetLineWidth(context, 10.0);
//    CGContextSetLineJoin(context, kCGLineJoinMiter);
//    CGContextSetMiterLimit(context,20.0);
//    CGContextStrokePath(context);
//    CGContextRelease(context);
//}

//填充
/**
 Quartz填充的时候会认为subpath是封闭的，然后根据规则来填充。有两种规则：
 
 nonzero winding number rule.沿着当前点，画一条直线到区域外，检查交叉点，如果交叉点从左到右，则加一，从右到左，则减去一。如果结果不为0，则绘制。
 
 even-odd rule,沿着当前点，花一条线到区域外，然后检查相交的路径，偶数则绘制，奇数则不绘制。
 CGContextEOFillPath － 用even-odd rule来填充
 CGContextFillPath － 用nonzero winding number rule方式填充
 CGContextFillRect/CGContextFillRects － 填充指定矩形区域内path
 CGContextFillEllipseInRect － 填充椭圆
 CGContextDrawPath － 绘制当前path（根据参数stroke/fill）
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
//- (void)drawRect:(CGRect)rect {
//    //获得当前context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //设置颜色
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    //为了颜色更好区分，对矩形描边
//    CGContextFillRect(context, rect);
//    CGContextStrokeRect(context, rect);
//
//
//    CGContextStrokePath(context);
//
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    CGContextAddEllipseInRect(context, CGRectMake(10, 10, 40, 20));
//    CGContextAddRect(context, CGRectMake(10, 10, 40, 20));
//
//    CGContextMoveToPoint(context, 0, 50);
//    CGContextAddCurveToPoint(context, 25, 0, 75, 100, 100, 50);
//    CGContextMoveToPoint(context, 0, 50);
//    CGContextAddQuadCurveToPoint(context, 50, 0, 100, 50);
//
//    CGContextStrokePath(context);
//
//    CGContextRelease(context);
//
//}



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
//    /**
//     线的宽度－CGContextSetLineWidth
//     交叉线的处理方式－CGContextSetLineJoin
//     线顶端的处理方式－CGContextSetLineCap
//     进一步限制交叉线的处理方式 －CGContextSetMiterLimit
//     是否要虚线－Line dash pattern
//     颜色控件－CGContextSetStrokeColorSpace
//     画笔颜色－CGContextSetStrokeColor/CGContextSetStrokeColorWithColor
//     描边模式－CGContextSetStrokePattern
//     */
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






















