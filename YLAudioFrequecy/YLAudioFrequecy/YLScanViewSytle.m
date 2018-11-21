//
//  YLScanViewSytle.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLScanViewSytle.h"
#import "YLScanViewSetting.h"




@implementation YLScanViewSytle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedShowRetangle = false;
        self.whRatio = 1.0;
        self.centerUpOffset = 44;
        self.xScanRetangleOffset = 60;
        self.colorRetangleLine = [UIColor whiteColor];
        self.photoframeAngleStyle = Inner;
        self.colorAngle = [UIColor colorWithRed:0.0 green: 167.0/255.0 blue:231.0/255.0 alpha:1];
        self.photoframeAngleW = 24.0;
        self.photoframeAngleH = 24.0;
        self.photoframeAngleW = 4;
        self.animationStyle = LineMove;
        self.animationImage = [YLScanViewSetting imageFromBundleWithName:@"qrcode_Scan_weixin_Line@2x"];
    }
    return self;
}

@end
