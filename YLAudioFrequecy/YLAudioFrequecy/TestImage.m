//
//  TestImage.m
//  YLAudioFrequecy
//
//  Created by hoggen on 2017/6/16.
//  Copyright © 2017年 ios-mac. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TestImage.h"

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

@implementation TestImage

- (UIImage *)resultImage {
    
    return [self testGraogic];
    
}

- (UIImage *)testGraogic {
    UIImage * image = [UIImage imageNamed:@"test"];
   // UIImage * newImage = [self imageByApplyingAlpha:0.5 image: [self newGost:image]];
     UIImage * newImage = [self changedImageAlpha: [self newGost:image]];
    NSUInteger width = CGImageGetWidth(newImage.CGImage);
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

/**
 *  设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
-(UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    
    CGContextSetAlpha(ctx, alpha);
    
    
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    
    UIGraphicsEndImageContext();
    
    
    
    return newImage;
    
}

- (UIImage *)changedImageAlpha:(UIImage *) image {
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    // 2.你需要定义一些参数bytesPerPixel（每像素大小)   =======
    NSUInteger bytesPerPixel = 4;
    //然后计算图像bytesPerRow（每行有大）
    size_t bytesPerRow = bytesPerPixel * imageWidth;
    //bitsPerComponent（每个颜色通道大小）
    NSUInteger bitsPerComponent = 8;
    //最后，使用一个数组来存储像素的值。
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    //创建GRB颜色空间,使用完毕后要释放颜色空间：
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /**
     当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项。alpha值决定了绘制像素的透明性。
     
     data                                    指向要渲染的绘制内存的地址。这个内存块的大小至少是（bytesPerRow*height）个字节
     width                                  bitmap的宽度,单位为像素
     height                                bitmap的高度,单位为像素
     bitsPerComponent        内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
     bytesPerRow                  bitmap的每一行在内存所占的比特数
     colorspace                      bitmap上下文使用的颜色空间。
     bitmapInfo                       指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
     CGContextRef context = CGBitmapContextCreate(<#void * _Nullable data#>, <#size_t width#>, <#size_t height#>, <#size_t bitsPerComponent#>, <#size_t bytesPerRow#>, <#CGColorSpaceRef  _Nullable space#>, <#uint32_t bitmapInfo#>)
     */
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, bitsPerComponent, bytesPerRow, colorSpace,  kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    // 4.把缓存中的图形绘制到显示器上。像素的填充格式是由你在创建context的时候进行指定的。
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素，透明背景
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i =0; i < pixelNum; i++, pCurPtr++)
    {
        //        if ((*pCurPtr & 0xFFFFFF00) == 0)    //将黑色变成透明
        uint8_t* ptr = (uint8_t*)pCurPtr;
        // Blend the ghost with 50% alpha
        CGFloat ghostAlpha = 0.5f * (A(* ptr) / 255.0);
        UInt32 newR = R(* ptr) * (1 -     ghostAlpha) + R(* ptr) * ghostAlpha;
        UInt32 newG = G(* ptr) * (1 -     ghostAlpha) + G(* ptr) * ghostAlpha;
        UInt32 newB = B(* ptr) * (1 -     ghostAlpha) + B(* ptr) * ghostAlpha;
        
        // Clamp, not really useful here :p
        newR = MAX(0,MIN(255, newR));
        newG = MAX(0,MIN(255, newG));
        newB = MAX(0,MIN(255, newB));
        
        ptr[3] = 177; //0~255
        ptr[2] = 177;
        ptr[1] = 122;
        
       // * ptr  = RGBAMake(177, 177, 122,     A(* ptr));
        
        
    }
    // 将内存转成image//将Data转换为Quartz直接访问的数据类型，目测其逻辑为制定数据内容，给定起始地址、长度等信息。
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    /**
     CGImageRef CGImageCreate (
     size_t width, //图片的宽度
     size_t height, //图片的高度
     size_t bitsPerComponent,  //图片每个颜色的bits，比如rgb颜色空间，有可能是5 或者 8 ==
     size_t bitsPerPixel,  //每一个像素占用的buts，15 位24位 32位等等
     size_t bytesPerRow, //每一行占用多少bytes 注意是bytes不是bits  1byte ＝ 8bit
     CGColorSpaceRef colorspace,  //颜色空间，比如rgb
     CGBitmapInfo bitmapInfo,  //layout ，像素中bit的布局， 是rgba还是 argb，＝＝
     CGDataProviderRef provider,  //数据源提供者，url或者内存＝＝
     const CGFloat decode[],  //一个解码数组
     bool shouldInterpolate,  //抗锯齿参数
     CGColorRenderingIntent intent
     //图片渲染相关参数
     );
     */
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, bitsPerComponent, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}

- (UIImage *)imageBlackToTransparent:(UIImage *) image {
    
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    // 2.你需要定义一些参数bytesPerPixel（每像素大小)   =======
    NSUInteger bytesPerPixel = 4;
    //然后计算图像bytesPerRow（每行有大）
    size_t bytesPerRow = bytesPerPixel * imageWidth;
    //bitsPerComponent（每个颜色通道大小）
    NSUInteger bitsPerComponent = 8;
    //最后，使用一个数组来存储像素的值。
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    //创建GRB颜色空间,使用完毕后要释放颜色空间：
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /**
     当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项。alpha值决定了绘制像素的透明性。
     
     data                                    指向要渲染的绘制内存的地址。这个内存块的大小至少是（bytesPerRow*height）个字节
     width                                  bitmap的宽度,单位为像素
     height                                bitmap的高度,单位为像素
     bitsPerComponent        内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
     bytesPerRow                  bitmap的每一行在内存所占的比特数
     colorspace                      bitmap上下文使用的颜色空间。
     bitmapInfo                       指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
     CGContextRef context = CGBitmapContextCreate(<#void * _Nullable data#>, <#size_t width#>, <#size_t height#>, <#size_t bitsPerComponent#>, <#size_t bytesPerRow#>, <#CGColorSpaceRef  _Nullable space#>, <#uint32_t bitmapInfo#>)
     */
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, bitsPerComponent, bytesPerRow, colorSpace,  kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    // 4.把缓存中的图形绘制到显示器上。像素的填充格式是由你在创建context的时候进行指定的。
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素，透明背景
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i =0; i < pixelNum; i++, pCurPtr++)
    {
        //if ((*pCurPtr & 0xFFFFFF00) == 0)
        if ((*pCurPtr & 0xFFFFFF00) >= 0xffffff00)
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] =0;
        }
        
    }
    // 将内存转成image//将Data转换为Quartz直接访问的数据类型，目测其逻辑为制定数据内容，给定起始地址、长度等信息。
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    /**
     CGImageRef CGImageCreate (
     size_t width, //图片的宽度
     size_t height, //图片的高度
     size_t bitsPerComponent,  //图片每个颜色的bits，比如rgb颜色空间，有可能是5 或者 8 ==
     size_t bitsPerPixel,  //每一个像素占用的buts，15 位24位 32位等等
     size_t bytesPerRow, //每一行占用多少bytes 注意是bytes不是bits  1byte ＝ 8bit
     CGColorSpaceRef colorspace,  //颜色空间，比如rgb
     CGBitmapInfo bitmapInfo,  //layout ，像素中bit的布局， 是rgba还是 argb，＝＝
     CGDataProviderRef provider,  //数据源提供者，url或者内存＝＝
     const CGFloat decode[],  //一个解码数组
     bool shouldInterpolate,  //抗锯齿参数
     CGColorRenderingIntent intent
     //图片渲染相关参数
     );
     */
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, bitsPerComponent, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
    
}

void ProviderReleaseData (void *info,const void *data,size_t size)
{
    free((void*)data);
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
    NSInteger targetGhostWidth = width * 0.15;
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
