//
//  TestImage.m
//  YLAudioFrequecy
//
//  Created by hoggen on 2017/6/16.
//  Copyright © 2017年 ios-mac. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TestImage.h"

@implementation TestImage

- (UIImage *)resultImage {
    
    return [self testGraogic];
    
}

- (UIImage *)testGraogic {
     UIImage * image = [UIImage imageNamed:@"test"];
    UIImage * newImage = [self newGost:image];
    NSUInteger width =                 CGImageGetWidth(newImage.CGImage);
    NSUInteger height = CGImageGetHeight(newImage.CGImage);

    //woman
    UIImage * womanImage = [UIImage imageNamed:@"woman"];
    // 1.获取图像宽高
    CGImageRef inputCGImage = [womanImage CGImage];
    NSUInteger womanImageWidth =                 CGImageGetWidth(inputCGImage);
    NSUInteger womanImageHeight = CGImageGetHeight(inputCGImage);

    UIGraphicsBeginImageContext(CGSizeMake(womanImageWidth, womanImageHeight));
    [womanImage drawInRect:CGRectMake(0, 0, womanImageWidth, womanImageHeight) ];
    [image drawInRect:CGRectMake(womanImageWidth - 80,  190, width, height)];
    UIImage * retrunImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retrunImage;
    
    
}


//- (UIImage *)addImage:(UIImage *) image {
//    //woman
//    UIImage * womanImage = [UIImage imageNamed:@"woman"];
//    // 1.获取图像宽高
//    CGImageRef inputCGImage = [womanImage CGImage];
//    NSUInteger womanImageWidth =                 CGImageGetWidth(inputCGImage);
//    NSUInteger womanImageHeight = CGImageGetHeight(inputCGImage);
//
//    // 2.你需要定义一些参数bytesPerPixel（每像素大小)   =======
//    NSUInteger bytesPerPixel = 4;
//    //然后计算图像bytesPerRow（每行有大）
//    NSUInteger bytesPerRow = bytesPerPixel * womanImageWidth;
//    //bitsPerComponent（每个颜色通道大小）
//    NSUInteger bitsPerComponent = 8;
//
//    UInt32 * pixels;
//    //最后，使用一个数组来存储像素的值。
//    pixels = (UInt32 *) calloc(womanImageWidth * womanImageHeight,     sizeof(UInt32));
//
//    // 3.创建一个RGB模式的颜色空间CGColorSpace和一个容器CGBitmapContext,将像素指针参数传递到容器中缓存进行存储。
//    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
//    CGContextRef context =     CGBitmapContextCreate(pixels, womanImageWidth, womanImageHeight,     bitsPerComponent, bytesPerRow, colorSpace,     kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
//
//    //定义了一些简单处理32位像素的宏。为了得到红色通道的值，你需要得到前8位。为了得到其它的颜色通道值，你需要进行位移并取截取。(define 里面)
//    NSLog(@"Brightness of image:");
//    // 2.定义一个指向第一个像素的指针，并使用2个for循环来遍历像素。其实也可以使用一个for循环从0遍历到width*height，但是这样写更容易理解图形是二维的。
////    UInt32 * currentPixel = pixels;
////    for (NSUInteger j = 0; j < height; j++) {
////        for (NSUInteger i = 0; i < width; i++) {
////            // 3.得到当前像素的值赋值给currentPixel并把它的亮度值打印出来。
////            UInt32 color = *currentPixel;
////            printf("%3.0f ",     (R(color)+G(color)+B(color))/3.0);
////            // 4.增加currentPixel的值，使它指向下一个像素。如果你对指针的运算比较生疏，记住这个：currentPixel是一个指向UInt32的变量，当你把它加1后，它就会向前移动4字节（32位），然后指向了下一个像素的值。
////            currentPixel++;
////        }
////        printf("\n");
////    }
////    // 4.把缓存中的图形绘制到显示器上。像素的填充格式是由你在创建context的时候进行指定的。
////    CGContextDrawImage(context, CGRectMake(0,     0, width, height), inputCGImage);
////
////    // 5. Cleanup 清除colorSpace和context.
////    CGColorSpaceRelease(colorSpace);
////    CGContextRelease(context);
////
////
//
//
//}

- (UIImage *)newGost:(UIImage *) image {
    CGImageRef ghostImage = [image CGImage];
    NSUInteger width =                 CGImageGetWidth(ghostImage);
    NSUInteger height = CGImageGetHeight(ghostImage);
    NSLog(@"width = %@, height = %@",@(width),@(height));
    CGFloat ghostImageAspectRatio = width / height;
    NSInteger targetGhostWidth = width * 0.25;
    CGSize ghostSize =     CGSizeMake(targetGhostWidth, targetGhostWidth / ghostImageAspectRatio);
    
    CGRect rect ;
    
    rect =CGRectMake(0,0, ghostSize.width,ghostSize.height);
    
    
    CGSize size = rect.size;
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:rect];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    // 2.你需要定义一些参数bytesPerPixel（每像素大小)   =======
//    NSUInteger bytesPerPixel = 4;
//    //然后计算图像bytesPerRow（每行有大）
//    NSUInteger bytesPerRow = bytesPerPixel *     width;
//    //bitsPerComponent（每个颜色通道大小）
//    NSUInteger bitsPerComponent = 8;
//    NSUInteger ghostBytesPerRow = bytesPerPixel * ghostSize.width;
//    
//    // 3.创建一个RGB模式的颜色空间CGColorSpace和一个容器CGBitmapContext,将像素指针参数传递到容器中缓存进行存储。
//    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
//    
//    UInt32 * ghostPixels = (UInt32     *)calloc(ghostSize.width * ghostSize.height,sizeof(UInt32));
//    
//    CGContextRef ghostContext =     CGBitmapContextCreate(ghostPixels,ghostSize.width, ghostSize.height,
//                                                          bitsPerComponent, ghostBytesPerRow, colorSpace,
//                                                          kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(ref,CGRectMake(0, 0, ghostSize.width,     ghostSize.height),ghostImage);
//    UInt32 * currentPixel = ghostPixels;
//    //    for (NSUInteger j = 0; j < ghostSize.height; j++) {
//    //        for (NSUInteger i = 0; i < ghostSize.width; i++) {
//    //            UInt32 color = *currentPixel;
//    //
//    //            UInt32 * ghostPixel = ghostPixels + j     * (int)ghostSize.width + i;
//    //            UInt32 ghostColor = *ghostPixel;
//    //
//    //            // Do some processing here
//    //
//    //            // Blend the ghost with 50% alpha
//    //            CGFloat ghostAlpha = 0.5f * (A(ghostColor)     / 255.0);
//    //            UInt32 newR = R(inputColor) * (1 -     ghostAlpha) + R(ghostColor) * ghostAlpha;
//    //            UInt32 newG = G(inputColor) * (1 -     ghostAlpha) + G(ghostColor) * ghostAlpha;
//    //            UInt32 newB = B(inputColor) * (1 -     ghostAlpha) + B(ghostColor) * ghostAlpha;
//    //
//    //            // Clamp, not really useful here :p
//    //            newR = MAX(0,MIN(255, newR));
//    //            newG = MAX(0,MIN(255, newG));
//    //            newB = MAX(0,MIN(255, newB));
//    //
//    //            *currentPixel = RGBAMake(newR, newG, newB,     A(inputColor));
//    //        }
//    //    }
//    UIImage * returnImage = [UIImage imageWithCGImage:ghostImage];
    NSLog(@"ghostSize.width = %@, ghostSize.height = %@",@(CGImageGetWidth(scaledImage.CGImage)),@(CGImageGetHeight(scaledImage.CGImage)));
    
    return scaledImage;
    
}

- (UIImage *)turnImage:(UIImage *)image {
    // 1.获取图像宽高
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width =                 CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    // 2.你需要定义一些参数bytesPerPixel（每像素大小)   =======
    NSUInteger bytesPerPixel = 4;
    //然后计算图像bytesPerRow（每行有大）
    NSUInteger bytesPerRow = bytesPerPixel *     width;
    //bitsPerComponent（每个颜色通道大小）
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    //最后，使用一个数组来存储像素的值。
    pixels = (UInt32 *) calloc(height * width,     sizeof(UInt32));
    
    // 3.创建一个RGB模式的颜色空间CGColorSpace和一个容器CGBitmapContext,将像素指针参数传递到容器中缓存进行存储。
    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
    CGContextRef context =     CGBitmapContextCreate(pixels, width, height,     bitsPerComponent, bytesPerRow, colorSpace,     kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    
    // 4.把缓存中的图形绘制到显示器上。像素的填充格式是由你在创建context的时候进行指定的。
    CGContextDrawImage(context, CGRectMake(0,     0, width, height), inputCGImage);
    
    // 5. Cleanup 清除colorSpace和context.
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    
    //    //定义了一些简单处理32位像素的宏。为了得到红色通道的值，你需要得到前8位。为了得到其它的颜色通道值，你需要进行位移并取截取。(define 里面)
    //    NSLog(@"Brightness of image:");
    //    // 2.定义一个指向第一个像素的指针，并使用2个for循环来遍历像素。其实也可以使用一个for循环从0遍历到width*height，但是这样写更容易理解图形是二维的。
    //    UInt32 * currentPixel = pixels;
    //    for (NSUInteger j = 0; j < height; j++) {
    //        for (NSUInteger i = 0; i < width; i++) {
    //            // 3.得到当前像素的值赋值给currentPixel并把它的亮度值打印出来。
    //            UInt32 color = *currentPixel;
    //            printf("%3.0f ",     (R(color)+G(color)+B(color))/3.0);
    //            // 4.增加currentPixel的值，使它指向下一个像素。如果你对指针的运算比较生疏，记住这个：currentPixel是一个指向UInt32的变量，当你把它加1后，它就会向前移动4字节（32位），然后指向了下一个像素的值。
    //            currentPixel++;
    //        }
    //        printf("\n");
    //    }
    //
    UIImage * returnImage = [UIImage imageWithCGImage:inputCGImage];
    return returnImage;
}

@end
