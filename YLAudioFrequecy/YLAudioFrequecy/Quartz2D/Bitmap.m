//
//  Bitmap.m
//  YLAudioFrequecy
//
//  Created by hoggen on 2017/6/18.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "Bitmap.h"

@implementation Bitmap

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
 Bitmap叫做位图，每一个像素点由1－32bit组成。每个像素点包括多个颜色组件和一个Alpha组件（例如：RGBA）。
 
 iOS中指出如下格式的图片 JPEG, GIF, PNG, TIF, ICO, GMP, XBM,和 CUR。其他格式的图片要给Quartz2D传入图片的数据分布信息。
 
 数据类型CGImageRef
 
 在Quartz中，Bitmap的数据由CGImageRef封装。由以下几个函数可以创建CGImageRef对象
 
 CGImageCreate － 最灵活，但也是最复杂的一种方式，要传入11个参数，这个方法最后讲解。
 CGImageSourceCreate-ImageAtIndex－通过已经存在的Image对象来创建
 CGImageSourceCreate-ThumbnailAtIndex－ 和上一个函数类似，不过这个是创建缩略图
 CGBitmapContextCreateImage － 通过Copy Bitmap Graphics来创建
先看看一个方法，创建bitmap context－CGBitmapContextCreate
 CGContextRef _Nullable CGBitmapContextCreate (
 void * _Nullable data,
 size_t width,
 size_t height,
 size_t bitsPerComponent,
 size_t bytesPerRow,
 CGColorSpaceRef _Nullable space,
 uint32_t bitmapInfo
 );
 data 是一个指针，指向存储绘制的bitmap context的实际数据的地址，最少大小为bytesPerRow* height.可以传入null,让quartz自动分配计算
 width/height bitmap的宽度，高度，以像素为单位
 bytesPerRow 每一行的byte数目。如果data传入null，这里传入0，则会自动计算
 一个component占据多少位。对于32bit的RGBA空间，则是8（8＊4＝32）。
 space 颜色空间，一般就是DeviceRGB
 bitmapInfo,一个常量，指定了是否具有alpha通道，alpha通道的位置，像素点存储的数据类型是float还是Integer等信息。

 */
- (UIImage *)test {
    CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
    CGSize targetSize = CGSizeMake(200, 100);
    uint32_t * rgbImageBuf = (uint32_t *)malloc(targetSize.width * 4 * targetSize.height);
    CGContextRef bitmapContext = CGBitmapContextCreate(rgbImageBuf,
                                                       targetSize.width,
                                                       targetSize.height,
                                                       8,
                                                       targetSize.width * 4,
                                                       rgbSpace,
                                                       kCGImageAlphaFirst);
    CGRect imageRect;
    imageRect.origin = CGPointMake(0, 0);
    imageRect.size = targetSize;
    UIImage * womanImage = [UIImage imageNamed:@"woman"];
    CGContextDrawImage(bitmapContext, imageRect, womanImage.CGImage);
    CGContextAddArc(bitmapContext, 100, 40, 20, M_PI_4, M_PI_2, true);
    CGContextSetLineWidth(bitmapContext, 4);
    CGContextStrokePath(bitmapContext);
    CGImageRef imageRef = CGBitmapContextCreateImage(bitmapContext);
    UIImage * image = [[UIImage alloc] initWithCGImage:imageRef];
    
    
    CGImageRelease(imageRef);
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(rgbSpace);
    return image;
    
    
    
}


@end







































