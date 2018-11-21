//
//  YLScanViewManager.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/21.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLScanViewManager.h"

@interface YLScanViewManager ()<YLScanViewControllerDelegate>
@property(nonatomic,strong)YLScanViewController * scanViewController;
@end

@implementation YLScanViewManager

-(instancetype)init {
    @throw [NSException exceptionWithName:@"单例类" reason:@"不能用此方法构造" userInfo:nil];
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        self.scanViewController = [YLScanViewController new];
    }
    return  self;
}
+(instancetype)sharedInstance {
    static YLScanViewManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] initPrivate];
        }
    });
    return  manager;
}


//显示扫描界面
-(void)showScanView:(UIViewController *)viewController {
    _scanViewController.delegate = self;
    _scanViewController.hidesBottomBarWhenPushed = true;
    [viewController.navigationController pushViewController:_scanViewController animated: true];
}

//生成二维码界面
/*
 frame: 生成视图的frame
 logoIconName：是否需要logo。可选
 codeMessage： 二维码包含信息
 **/
-(UIView *)produceQRcodeView:(CGRect)frame logoIconName:(NSString *)logoIconName codeMessage:(NSString *)codeMessage{
    UIView * QRCodeView = [YLScanViewSetting QRcodeView];
    QRCodeView.frame = frame;
    UIImageView * imageView = [YLScanViewSetting creatQRCodeView:QRCodeView.bounds codeMessage:codeMessage logoName:logoIconName];
    [QRCodeView addSubview:imageView];
    return QRCodeView;
}




-(void)setIsNeedShowRetangle:(BOOL)isNeedShowRetangle {
    _scanViewController.scanStyle.isNeedShowRetangle = isNeedShowRetangle;
    _isNeedShowRetangle = isNeedShowRetangle;
}

- (void)setColorRetangleLine:(UIColor *)colorRetangleLine {
    _scanViewController.scanStyle.colorRetangleLine = colorRetangleLine;
    _colorRetangleLine = colorRetangleLine;
}

- (void)setWhRatio:(float)whRatio {
    _scanViewController.scanStyle.whRatio = whRatio;
    _whRatio = whRatio;
}

-(void)setCenterUpOffset:(float)centerUpOffset {
    _scanViewController.scanStyle.centerUpOffset = centerUpOffset;
    _centerUpOffset =centerUpOffset;
}
- (void)setScanViewWidth:(float)scanViewWidth {
    _scanViewController.scanStyle.xScanRetangleOffset = ([UIScreen mainScreen].bounds.size.width - scanViewWidth) / 2;
    _scanViewWidth = scanViewWidth;
}

- (void)setPhotoframeAngleStyle:(YLScanViewPhotoframeAngleStyle)photoframeAngleStyle {
    _scanViewController.scanStyle.photoframeAngleStyle = photoframeAngleStyle;
    _photoframeAngleStyle = photoframeAngleStyle;
}

- (void)setColorAngle:(UIColor *)colorAngle {
    _scanViewController.scanStyle.colorAngle = colorAngle;
    _colorAngle = colorAngle;
}

- (void)setPhotoframeLineW:(float)photoframeLineW {
    _scanViewController.scanStyle.photoframeLineW = photoframeLineW;
    _photoframeLineW = photoframeLineW;
}

- (void)setImageStyle:(YLAnimationImageStyle)imageStyle {
    switch (imageStyle) {
        case firstLine:{
            _scanViewController.scanStyle.animationImage = [ YLScanViewSetting imageFromBundleWithName:@"qrcode_Scan_weixin_Line@2x"];
            break;
        }
        case secondeLine:{
            _scanViewController.scanStyle.animationImage = [ YLScanViewSetting imageFromBundleWithName:@"qrcode_scan_light_green@2x"];
            break;
        }
        case firstNetGrid:{
            _scanViewController.scanStyle.animationImage = [ YLScanViewSetting imageFromBundleWithName:@"qrcode_scan_full_net"];
            break;
        }
        case secondeNetGrid:{
            _scanViewController.scanStyle.animationImage = [ YLScanViewSetting imageFromBundleWithName:@"qrcode_scan_part_net"];
            break;
        }
        default:
            break;
    }
}

-(void)setAnimationImage:(UIImage *)animationImage {
    _scanViewController.scanStyle.animationImage = animationImage;
    _animationImage = animationImage;
}

-(void)scanViewControllerSuccessWith:(YLScanResult *)result {
    if (self.delegate != nil) {
        [self.delegate scanViewControllerSuccessWith: result];
    }
}



@end
