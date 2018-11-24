//
//  YLScanViewSetting.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLScanResult.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ExternalBlock)(NSMutableArray<YLScanResult*> *);

@interface YLScanViewSetting : NSObject

@property (nonatomic, strong)AVCaptureDevice *device;
@property (nonatomic, strong)AVCaptureDeviceInput * input;
@property (nonatomic, strong)AVCaptureMetadataOutput *output;
@property (nonatomic, strong)AVCaptureSession *session;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong)NSMutableArray<YLScanResult*> *arrayResult;
@property (nonatomic, copy) void (^succesBlock)(NSMutableArray<YLScanResult*> *);
@property (nonatomic, assign)BOOL isNeedCaptureImage;
@property (nonatomic, assign)BOOL isNeedScanResult;
//@property (nonatomic, strong)UIView *QRcodeView;
@property (nonatomic, strong)NSArray *defaultMetaDataObjectTypes;


-(instancetype)initWith:(UIView *)videoPreView objType:(NSArray<NSString *> *)objType isCaptureImg:(BOOL)isCaptureImg cropRect:(CGRect)cropRect success:(ExternalBlock)infoBlock;

-(void)start;
-(void)stop;
-(BOOL)isGetFlash ;
-(void)changeTorch;
-(void)setTorch:(BOOL)torch;
+(UIView *)QRcodeView;
/**
 识别二维码码图像
 
 - parameter image: 二维码图像
 
 - returns: 返回识别结果
 */
+(NSArray<YLScanResult *> *)recognizeQRImage:(UIImage *)image ;

+(UIImage *)imageFromBundleWithName:(NSString *)name;
/**
 图像中间加logo图片
 加Logo的图像
 */
+(UIImageView *)creatQRCodeView:(CGRect)bound codeMessage:(NSString *)codeMessage logoName:(NSString *)logoName ;

+(UIImage *)getConcreteCodeImage:(UIImage *)srcCodeImage codeResult:(YLScanResult *)codeResult;

@end

NS_ASSUME_NONNULL_END
