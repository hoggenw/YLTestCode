//
//  YLScanResult.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLScanResult.h"

@implementation YLScanResult

-(instancetype)initWith:(NSString *)strScanned img:(UIImage *)imgScanned barCodeType:(NSString *)strBarCodeType corner:(NSArray * )arrayCorner {
    if (self = [super init]) {
        self.strScanned = strScanned;
        self.imgScanned = imgScanned;
        self.strBarCodeType = strBarCodeType;
        self.arrayCorner = [NSArray arrayWithArray: arrayCorner];
    }
    return  self;
}

@end
