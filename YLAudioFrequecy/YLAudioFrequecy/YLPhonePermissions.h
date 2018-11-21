//
//  YLPhonePermissions.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPhonePermissions : NSObject

/*
 *相机权限
 */
+(BOOL)isGetCameraPermission;

/*
 *相册权限
 */
+(BOOL)isGetPhotoPermission;

@end

NS_ASSUME_NONNULL_END
