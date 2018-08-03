//
//  UIImage+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


/**
 *  获取指定颜色的1像素的图片
 */
+ (instancetype)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 1;
    CGFloat imageH = 1;
    
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  根据图片的中心点去拉伸图片并返回
 */
- (UIImage *)resizableImageWithCenterPoint
{
    CGFloat top = (self.size.height * 0.5 - 1); // 顶端盖高度
    CGFloat bottom = top ;                      // 底端盖高度
    CGFloat left = (self.size.width * 0.5 -1);  // 左端盖宽度
    CGFloat right = left;                       // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage * image = [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    return image;
}

//压缩图片大小(长宽同时乘以ratio)
- (UIImage *)compressImage:(float )ratio  {
    
    CGSize imageSize = self.size;
    
    CGFloat width = imageSize.width * ratio;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = ratio * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, targetHeight));
    [self drawInRect:CGRectMake(0, 0, width, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//压缩图片到指定大小()
- (UIImage *)compressImageWithSice:(CGSize )rectSize  {
    
    
    CGFloat width = rectSize.width;
    CGFloat height = rectSize.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width ,height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)gradientImageStartColor:(UIColor *)startColor endColor:(UIColor *) endColor bounds:(CGRect) bounds{
    //创建CGContextRef
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = bounds;
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [UIImage drawLinearGradient:gc path:path startColor: startColor.CGColor endColor: endColor.CGColor];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  img;
}

+ (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


- (YLImageType )typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return YLImageJpeg;
            
        case 0x89:
            
            return YLImagePng;
            
        case 0x47:
            
            return YLImageGif;
            
        case 0x49:
            
        case 0x4D:
            
            return YLImageTiif;
            
    }
    
    return YLImageUnkonw;
    
}

@end
