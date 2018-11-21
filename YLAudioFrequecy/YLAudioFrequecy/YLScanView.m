//
//  YLScanView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLScanView.h"

@implementation YLScanView

-(void)dealloc{
    if (self.scanLineAnimation != nil) {
        [self.scanLineAnimation stopStepAnimation];
    }
    if (self.scanNetAnimation != nil) {
        [self.scanNetAnimation stopStepAnimation];
    }
}

-(instancetype)initWithFrame:(CGRect)frame scanViewStyle:(YLScanViewSytle *)viewStyle{
    if (self = [super init]) {
        _viewStyle = [YLScanViewSytle new];
        _scanRetangleRect = CGRectZero;
        _fixedLine = [UIImageView new];
        _isAnimationing = false;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawScanRect];
}

-(void)drawScanRect {
    float XRetangleLeft = self.viewStyle.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft * 2, self.frame.size.width -  XRetangleLeft * 2);
    if (_viewStyle.whRatio != 1.0) {
        float width = sizeRetangle.width;
        float height = width / _viewStyle.whRatio;
        sizeRetangle = CGSizeMake(width, height);
    }
    //扫描区域Y轴最小坐标
    float YminRetangle = self.frame.size.height/2.0 - sizeRetangle.height/2.0 - _viewStyle.centerUpOffset;
    float YmaxRetangle = YminRetangle + sizeRetangle.height;
    float XretangleRight = self.frame.size.width - XRetangleLeft;
    
    //非扫码区域绘制
    CGContextRef  context = UIGraphicsGetCurrentContext();
    //非扫码区域半透明
    //设置非识别区域颜色
    CGContextSetRGBFillColor(context, red_notRecoginitonArea, green_notRecoginitonArea, blue_notRecoginitonArea, alpa_notRecoginitonArea);
    //填充区域
    //扫码区域上填充
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, YminRetangle);
    CGContextFillRect(context, rect);
    //左边
    rect = CGRectMake( 0, YminRetangle, XRetangleLeft,  sizeRetangle.height);
    CGContextFillRect(context, rect);
    //右边
    rect =  CGRectMake(  XretangleRight,  YminRetangle, XRetangleLeft, sizeRetangle.height);
    CGContextFillRect(context, rect);
    //下边
    rect =  CGRectMake(  0, YmaxRetangle,  self.frame.size.width, self.frame.size.height - YmaxRetangle);
    CGContextFillRect(context, rect);
    //执行绘画
    CGContextStrokePath(context);
    
    if (_viewStyle.isNeedShowRetangle) {
        CGContextSetStrokeColorWithColor(context, _viewStyle.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddRect(context, CGRectMake(XRetangleLeft, YminRetangle, sizeRetangle.width, sizeRetangle.height));
        //执行绘画
        CGContextStrokePath(context);
    }
    
    _scanRetangleRect = CGRectMake( XRetangleLeft,  YminRetangle, sizeRetangle.width, sizeRetangle.height);
    //画矩形框的框度和高度
    float widthAnlge = _viewStyle.photoframeAngleW;
    float heightAnlge = _viewStyle.photoframeAngleH;
    //4个角的线的高度
    float linewidthAngle = _viewStyle.photoframeLineW;
    //画扫码矩形以及周边半透明黑色坐标参数
    float diffAngle = linewidthAngle/3;//框外面4个角，与框紧密联系在一起
    //        diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
    //        diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //        diffAngle = 0;//与矩形框重合
    switch (_viewStyle.photoframeAngleStyle ) {
        case Outer:
            diffAngle = linewidthAngle/3;//框外面4个角，与框紧密联系在一起
            break;
        case On:
            diffAngle = 0;//框外面4个角，与框紧密联系在一起
            break;
        case Inner:
            diffAngle = _viewStyle.photoframeLineW/2;//框外面4个角，与框紧密联系在一起
            break;
            
        default:
            break;
    }
    
    CGContextSetStrokeColorWithColor(context, _viewStyle.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, linewidthAngle);
    
    
    //
    float leftX = XRetangleLeft - diffAngle;
    float topY = YminRetangle - diffAngle;
    float rightX = XretangleRight + diffAngle;
    float bottomY = YmaxRetangle + diffAngle;
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + widthAnlge, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+heightAnlge);
    
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + widthAnlge, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(context, leftX,  bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - heightAnlge);
    
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2,  topY);
    CGContextAddLineToPoint(context, rightX - widthAnlge, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(context, rightX,  topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + heightAnlge);
    
    //        右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2,  bottomY);
    CGContextAddLineToPoint(context, rightX - widthAnlge, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(context, rightX,  bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - heightAnlge);
    
    
    CGContextStrokePath(context);
}

-(void)startScanAnimation {
    if (_isAnimationing) {
        return;
    }
    
    _isAnimationing = true;
    //扫码区域坐标
    CGRect cropRect = [YLScanView getScanRectForAnimation:_viewStyle frame: self.frame];
    switch (_viewStyle.animationStyle) {
        case LineMove:{
            [self.scanLineAnimation startAnimationingWithRect:cropRect parentView:self image:_viewStyle.animationImage];
            break;
        }
        case NetGrid:{
            [self.scanNetAnimation startAnimationingWithRect:cropRect parentView:self image:_viewStyle.animationImage];
            break;
        }
        case LineStill:{
            CGRect stillRect = CGRectMake(cropRect.origin.x+20,
                                          cropRect.origin.y + cropRect.size.height/2,
                                          cropRect.size.width-40,
                                          2);
            _fixedLine.frame = stillRect;
            [self addSubview: _fixedLine];
            [_fixedLine setHidden:false];
            break;
        }
        default:
            break;
    }
    
}

+(CGRect)getScanRectForAnimation:(YLScanViewSytle *)viewStyle frame:(CGRect)frame {
    float XRetangleLeft = viewStyle.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft * 2, frame.size.width -  XRetangleLeft * 2);
    if (viewStyle.whRatio != 1) {
        float width = sizeRetangle.width;
        float height = width / viewStyle.whRatio;
        sizeRetangle = CGSizeMake( width,  height);
    }
    //扫描区域Y轴最小坐标
    float YminRetangle = frame.size.height/2.0 - sizeRetangle.height/2.0 - viewStyle.centerUpOffset;
    
    CGRect cropRect = CGRectMake(XRetangleLeft, YminRetangle, sizeRetangle.width, sizeRetangle.height);
    return cropRect;
}

-(void)deviceStartReadying:(NSString *) readyStr{
    
    float XRetangleLeft = _viewStyle.xScanRetangleOffset;
    
    CGSize sizeRetangle = [self getRetangeSize];
    
    //扫码区域Y轴最小坐标
    float YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - _viewStyle.centerUpOffset;
    
    //设备启动状态提示
    if (_activityView == nil)
    {
        self.activityView =  [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 30, 30)];
        _activityView.center = CGPointMake( XRetangleLeft +  sizeRetangle.width/2 - 50,YMinRetangle + sizeRetangle.height/2);
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        [self addSubview: _activityView];
        
        
        CGRect labelReadyRect = CGRectMake(_activityView.frame.origin.x + _activityView.frame.size.width + 10, _activityView.frame.origin.y, 100,  30);
        //print("%@",NSStringFromCGRect(labelReadyRect))
        self.labelReadying = [[UILabel alloc] initWithFrame:labelReadyRect];
        _labelReadying.text = readyStr;
        _labelReadying.backgroundColor = UIColor.clearColor;
        _labelReadying.textColor = UIColor.whiteColor;
        _labelReadying.font = [UIFont systemFontOfSize:18];
        [self addSubview: _labelReadying];
    }
    
    [_activityView startAnimating];
}

-(CGSize)getRetangeSize {
    float XRetangleLeft = _viewStyle.xScanRetangleOffset;
    
    CGSize sizeRetangle = CGSizeMake( self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    
    float w = sizeRetangle.width;
    float h = w / _viewStyle.whRatio;
    
    
    int hInt= (int) h;
    h = (float) hInt;
    
    sizeRetangle = CGSizeMake(w,  h);
    
    return sizeRetangle;
}

-(void)stopScanAnimtion {
    _isAnimationing = false;
    switch (_viewStyle.animationStyle) {
        case LineMove:{
            [self.scanLineAnimation stopStepAnimation];
            break;
        }
        case NetGrid:{
            [self.scanNetAnimation stopStepAnimation];
            break;
        }
        case LineStill:{
            [_fixedLine setHidden:true];
            break;
        }
        default:
            break;
    }
}

-(void)deviceStopReadying {
    if (_activityView != nil) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        [_labelReadying removeFromSuperview];
        
        _activityView = nil;
        _labelReadying = nil;
        
    }
}

+(CGRect)getScanRectWithPreview:(UIView *)preview style:(YLScanViewSytle *)style {
    CGRect cropRect = [YLScanView getScanRectForAnimation:style frame:preview.frame];
    //计算兴趣区域
    CGRect rectOfInterest;
    CGSize size = preview.bounds.size;
    float p1 = size.height/size.width;
    float p2 = 1920.0/1080.0; //使用1080p的图像输出
    if (p1 < p2) {
        float fixHeight = size.width * 1920.0 / 1080.0;
        float fixPadding = (fixHeight - size.height)/2;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                    cropRect.origin.x/size.width,
                                    cropRect.size.height/fixHeight,
                                    cropRect.size.width/size.width);
    }else {
        float fixWidth = size.height * 1080.0 / 1920.0;
        float fixPadding = (fixWidth - size.width)/2;
        rectOfInterest = CGRectMake( cropRect.origin.y/size.height,
                                    (cropRect.origin.x + fixPadding)/fixWidth,
                                    cropRect.size.height/size.height,
                                    cropRect.size.width/fixWidth);
    }
    
    return rectOfInterest;
}

@end


