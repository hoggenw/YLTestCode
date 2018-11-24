//
//  YLScanResult.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLScanResult : NSObject

@property (nonatomic, copy)NSString *strScanned;
@property (nonatomic, strong)UIImage *imgScanned;
@property (nonatomic, copy)NSString *strBarCodeType;
@property (nonatomic, strong)NSArray *arrayCorner;

-(instancetype)initWith:(NSString *)strScanned img:(UIImage *)imgScanned barCodeType:(NSString *)strBarCodeType corner:(NSArray *)arrayCorner;

@end

NS_ASSUME_NONNULL_END
