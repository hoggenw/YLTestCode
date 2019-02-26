//
//  YLScanViewSetting.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLScanViewSetting.h"

#import "YLScanViewController.h"

@interface YLScanViewSetting ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation YLScanViewSetting


-(void)dealloc {
    NSLog(@"YLScanSetting deinit");
}


-(instancetype)initWith:(UIView *)videoPreView objType:(NSArray<NSString *> *)objType isCaptureImg:(BOOL)isCaptureImg cropRect:(CGRect)cropRect success:(ExternalBlock)infoBlock {
    if (self = [super init]) {
        self.isNeedScanResult = true;
        _input = [AVCaptureDeviceInput deviceInputWithDevice: self.device error:nil];
        self.succesBlock = infoBlock;
        self.isNeedCaptureImage = isCaptureImg;
        if (objType == nil || objType.count <= 0) {
            objType = @[AVMetadataObjectTypeQRCode];
        }
        
        self.stillImageOutput = [AVCaptureStillImageOutput new];
        self.output = [AVCaptureMetadataOutput new];
        if ([self.session canAddInput:self.input]) {
            [self.session addInput: self.input];
        }
        if ([self.session canAddOutput: self.output]) {
            [self.session addOutput:self.output];
        }
        if ([self.session canAddOutput: self.stillImageOutput]) {
            [self.session addOutput: self.stillImageOutput];
        }
        
        NSDictionary * outputSettings = @{AVVideoCodecJPEG : AVVideoCodecKey};
        self.stillImageOutput.outputSettings = outputSettings;
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        //参数设置
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        self.output.metadataObjectTypes = objType;
        if (!CGRectContainsRect(cropRect, CGRectZero)) {
            self.output.rectOfInterest = cropRect;
        }
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        CGRect frame = videoPreView.frame;
        frame.origin = CGPointZero;
        self.previewLayer.frame = frame;
        [videoPreView.layer insertSublayer:self.previewLayer atIndex: 0];
        if (self.device.isFocusPointOfInterestSupported && [self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.input.device lockForConfiguration:nil];
            self.input.device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [self.input.device unlockForConfiguration];
        }
        
        
    }
    return  self;
}

-(void)start{
    if(!self.session.isRunning){
        self.isNeedScanResult = true;
        [self.session startRunning];
    }
}
-(void)stop {
    if(self.session.isRunning){
        self.isNeedScanResult = false;
        [self.session stopRunning];
    }
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (!self.isNeedScanResult){
        return;
    }
    self.isNeedScanResult = false;
    [self.arrayResult removeAllObjects];
    for (AVMetadataObject * current in metadataObjects) {
        AVMetadataMachineReadableCodeObject * code = (AVMetadataMachineReadableCodeObject *) current;
        [self.arrayResult addObject: [[YLScanResult alloc] initWith:code.stringValue img: [UIImage new] barCodeType: [code type] corner:[code corners]]];
    }
    
    if (self.arrayResult.count >0) {
        if (self.isNeedCaptureImage) {
            [self captureImage];
        }else {
            [self stop];
            self.succesBlock(self.arrayResult);
        }
    }
}

-(void)captureImage{
    AVCaptureConnection *stillImageConnection = [self connectionWithMediaType:AVMediaTypeVideo connections: self.stillImageOutput.connections];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        [self stop];
        if (imageDataSampleBuffer != nil) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage * scanImg = [UIImage imageWithData: imageData];
            for (int index = 0;  index <= self.arrayResult.count-1;  index ++) {
                self.arrayResult[index].imgScanned = scanImg;
            }
            
        }
        self.succesBlock(self.arrayResult);
    }];
    
}

-(BOOL)isGetFlash {
    if (self.device != nil && self.device.hasFlash && self.device.hasTorch) {
        return  true;
    }
    return  false;
}

/**
 打开或关闭闪关灯
 - parameter torch: true：打开闪关灯 false:关闭闪光灯
 */
-(void)setTorch:(BOOL)torch {
    if ([self isGetFlash]) {
        [self.input.device lockForConfiguration:nil];
        self.input.device.torchMode = torch;
        [self.input.device unlockForConfiguration];
    }
    
}
/**
 ------闪光灯打开或关闭
 */
-(void)changeTorch {
    if ([self isGetFlash]) {
        [self.input.device lockForConfiguration:nil];
        BOOL torch = false;
        if (self.input.device.torchMode == AVCaptureTorchModeOff) {
            torch = true;
        }
        self.input.device.torchMode = torch? AVCaptureTorchModeOn: AVCaptureTorchModeOff;
        [self.input.device unlockForConfiguration];
    }
}


-(AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType connections:(NSArray<AVCaptureConnection *> *)connections {
    for (AVCaptureConnection * connection in connections) {
        for (NSObject *port in connection.inputPorts) {
            if ([port isKindOfClass:AVCaptureInputPort.class]) {
                AVCaptureInputPort *portTmp = (AVCaptureInputPort *)port;
                if (portTmp.mediaType == mediaType) {
                    return  connection;
                }
            }
        }
    }
    return nil;
}

+(UIImage *)imageFromBundleWithName:(NSString *)name {
    NSBundle * filePathBundle = [YLScanViewSetting resourceWithName];
    NSString * imageFilePath = [filePathBundle pathForResource:name ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile: imageFilePath];
    return  image;
    
}

+(NSBundle *)resourceWithName {
    NSBundle * scanViewBunlde = [NSBundle bundleForClass: YLScanViewController.class];
    NSBundle * returnBundel =  [NSBundle  bundleWithPath: [scanViewBunlde.bundlePath stringByAppendingString:@"/YLOCScan.bundle"]];
    return  returnBundel;
}


-(AVCaptureDevice *)device {
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return  _device;
}
-(AVCaptureSession *)session {
    if (_session == nil) {
        _session = [AVCaptureSession new];
    }
    
    return  _session;
}

-(NSMutableArray<YLScanResult*> *)arrayResult {
    if (_arrayResult == nil) {
        _arrayResult = [NSMutableArray array];
    }
    return _arrayResult;
}

+(UIView *)QRcodeView {
    UIView * QRcodeView = [UIView new];
    QRcodeView.backgroundColor = [UIColor whiteColor];
    QRcodeView.layer.shadowOffset = CGSizeMake(0, 2);
    QRcodeView.layer.shadowRadius = 2;
    QRcodeView.layer.shadowColor = UIColor.blackColor.CGColor;
    QRcodeView.layer.shadowOpacity = 0.5;
    return  QRcodeView;
}

-(NSArray *)defaultMetaDataObjectTypes {
    NSMutableArray * array = [NSMutableArray arrayWithArray: @[AVMetadataObjectTypeQRCode,
                                                               AVMetadataObjectTypeUPCECode,
                                                               AVMetadataObjectTypeCode39Code,
                                                               AVMetadataObjectTypeCode39Mod43Code,
                                                               AVMetadataObjectTypeEAN13Code,
                                                               AVMetadataObjectTypeEAN8Code,
                                                               AVMetadataObjectTypeCode93Code,
                                                               AVMetadataObjectTypeCode128Code,
                                                               AVMetadataObjectTypePDF417Code,
                                                               AVMetadataObjectTypeAztecCode,
                                                               ]];
    [array addObject:AVMetadataObjectTypeInterleaved2of5Code];
    [array addObject:AVMetadataObjectTypeITF14Code];
    [array addObject:AVMetadataObjectTypeDataMatrixCode];
    [array addObject:AVMetadataObjectTypeInterleaved2of5Code];
    [array addObject:AVMetadataObjectTypeITF14Code];
    [array addObject:AVMetadataObjectTypeDataMatrixCode];
    return  [array copy];
}
/**
 识别二维码码图像
 
 - parameter image: 二维码图像
 
 - returns: 返回识别结果
 */
+(NSArray<YLScanResult *> *)recognizeQRImage:(UIImage *)image {
    NSMutableArray<YLScanResult *> *returnResult = [NSMutableArray array];
    if (@available(iOS 8.0, *)) {
        CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        CIImage *img = [CIImage imageWithCGImage: image.CGImage];
        NSArray<CIFeature *> *features = [detector featuresInImage: img options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        if (features != nil && features.count >0) {
            CIFeature *feature = features.firstObject;
            if ([feature isKindOfClass: CIQRCodeFeature.class]) {
                CIQRCodeFeature * featureTmp = (CIQRCodeFeature *)feature;
                NSString * scanResult = featureTmp.messageString;
                YLScanResult *result = [[YLScanResult alloc] initWith:scanResult img: image barCodeType:AVMetadataObjectTypeQRCode corner:nil];
                [returnResult addObject: result];
            }
        }
    }
    return  returnResult;
}
/**
 @brief  图像中间加logo图片
 @param srcImg    原图像
 @param LogoImage logo图像
 @param logoSize  logo图像尺寸
 @return 加Logo的图像
 */

+(UIImageView *)creatQRCodeView:(CGRect)bound codeMessage:(NSString *)codeMessage logoName:(NSString *)logoName {
    UIImage * qrImg = [YLScanViewSetting createCode:@"CIQRCodeGenerator" codeString:codeMessage size:bound.size qrColor:UIColor.blackColor bkColor:UIColor.whiteColor];
    UIImageView *qrImgView = [UIImageView new];
    qrImgView.frame = bound;
    if (logoName.length >0) {
        UIImage * logoImg = [UIImage imageNamed: logoName];
        qrImgView.image = [YLScanViewSetting addImageLogoWith:qrImg logoImg:logoImg logoSize:CGSizeMake(30, 30)];
        
    }else{
        qrImgView.image = [YLScanViewSetting addImageLogoWith:qrImg logoImg:nil logoSize:CGSizeMake(30, 30)];
    }
    return  qrImgView;
}

+(UIImage *)createCode:(NSString *)codeType codeString:(NSString *)codeString size:(CGSize)size qrColor:(UIColor *)qrColor bkColor:(UIColor *)bkColor {
    NSData * stringData = [codeString dataUsingEncoding: NSUTF8StringEncoding];
    //系统自带能生成的码
    //        CIAztecCodeGenerator
    //        CICode128BarcodeGenerator
    //        CIPDF417BarcodeGenerator
    //        CIQRCodeGenerator
    CIFilter * qrFilter = [CIFilter filterWithName: codeType];
    [qrFilter setValue:stringData forKey: @"inputMessage"];
    [qrFilter setValue:@"H" forKey: @"inputCorrectionLevel"];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName: @"CIFalseColor" withInputParameters:@{@"inputImage":qrFilter.outputImage,@"inputColor0":[CIColor colorWithCGColor:qrColor.CGColor],@"inputColor1":[CIColor colorWithCGColor:bkColor.CGColor]}];
    CIImage * qrImage = colorFilter.outputImage;
    //绘制
    UIGraphicsBeginImageContext(size);
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), [[CIContext new] createCGImage:qrImage fromRect:qrImage.extent]);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  codeImage;
}

+(UIImage *)addImageLogoWith:(UIImage *)srcImg logoImg:(UIImage *)logoImg logoSize:(CGSize)logoSize {
    UIGraphicsBeginImageContext(srcImg.size);
    [srcImg drawInRect:CGRectMake(0, 0, srcImg.size.width, srcImg.size.height)];
    CGRect rect = CGRectMake(srcImg.size.width/2 - logoSize.width/2, srcImg.size.height/2-logoSize.height/2, logoSize.width, logoSize.height);
    if (logoImg != nil) {
        [logoImg drawInRect: rect];
    }
    
    
    UIImage * resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
 //MARK:根据扫描结果，获取图像中得二维码区域图像（如果相机拍摄角度故意很倾斜，获取的图像效果很差）
+(UIImage *)getConcreteCodeImage:(UIImage *)srcCodeImage codeResult:(YLScanResult *)codeResult {
    CGRect rect = [YLScanViewSetting getConcreteCodeRectFromImage: srcCodeImage codeResult:codeResult];
    if (CGRectContainsRect(rect, CGRectNull)) {
        return  nil;
    }
    UIImage * img = [YLScanViewSetting imageByCroppingWithStyle: srcCodeImage rect: rect];
    if (img != nil) {
        UIImage * imgRotation = [YLScanViewSetting imageRotation: img orientation: UIImageOrientationRight];
        return  imgRotation;
    }
    return  nil;
}
 //图像裁剪
+(UIImage *)imageByCroppingWithStyle:(UIImage *)srcImg rect:(CGRect)rect {
    CGImageRef  imageRef = srcImg.CGImage ;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return  thumbScale;
}
 //获取二维码的图像区域
+(CGRect)getConcreteCodeRectFromImage:(UIImage*)srcCodeImage codeResult:(YLScanResult *)codeResult {
    if (codeResult.arrayCorner == nil || codeResult.arrayCorner.count < 4) {
        return  CGRectZero;
    }
    NSArray<NSDictionary *> *corner = codeResult.arrayCorner;
    NSDictionary * dicTopLeft     = corner[0];
    NSDictionary * dicTopRight    = corner[1];
    NSDictionary * dicBottomRight = corner[2];
    NSDictionary * dicBottomLeft  = corner[3];
    
    float xLeftTopRatio = [[NSString stringWithFormat:@"%@",dicTopLeft[@"X"]] floatValue];
    float yLeftTopRatio  = [[NSString stringWithFormat:@"%@",dicTopLeft[@"Y"]] floatValue];
    
    float xRightTopRatio = [[NSString stringWithFormat:@"%@",dicTopRight[@"X"]] floatValue];
    float yRightTopRatio = [[NSString stringWithFormat:@"%@",dicTopRight[@"Y"]] floatValue];
    
    float xBottomRightRatio = [[NSString stringWithFormat:@"%@",dicBottomRight[@"X"]] floatValue];
    float yBottomRightRatio = [[NSString stringWithFormat:@"%@",dicBottomRight[@"Y"]] floatValue];
    
    float xLeftBottomRatio = [[NSString stringWithFormat:@"%@",dicBottomLeft[@"X"]] floatValue];
    float yLeftBottomRatio = [[NSString stringWithFormat:@"%@",dicBottomLeft[@"Y"]] floatValue];
    //由于截图只能矩形，所以截图不规则四边形的最大外围
    float xMinLeft =  MIN(xLeftTopRatio,xLeftBottomRatio);
    float xMaxRight = MAX(xRightTopRatio, xBottomRightRatio);
    
    float yMinTop = MIN(yLeftTopRatio, yRightTopRatio);
    float yMaxBottom = MAX(yLeftBottomRatio, yBottomRightRatio);
    
    float imgW = srcCodeImage.size.width;
    float imgH = srcCodeImage.size.height;
    
    return CGRectMake(xMinLeft * imgH, yMinTop*imgW, (xMaxRight-xMinLeft)*imgH,  (yMaxBottom-yMinTop)*imgW);
    
}

+(UIImage * )imageRotation:(UIImage *)image orientation:(UIImageOrientation)orientation{
    double rotate = 0.0;
    CGRect rect;
    float translateX = 0.0;
    float translateY = 0.0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate =  M_PI / 2;
            rect = CGRectMake( 0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI/ 2;
            rect = CGRectMake(  0,  0, image.size.height,  image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect =CGRectMake(  0,  0,  image.size.width,  image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(   0,  0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef  context  = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
     CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage * newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
    
}


@end

