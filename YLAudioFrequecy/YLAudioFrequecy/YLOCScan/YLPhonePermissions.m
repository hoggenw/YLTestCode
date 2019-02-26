//
//  YLPhonePermissions.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLPhonePermissions.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>


@implementation YLPhonePermissions

/**
 *typedef NS_ENUM(NSInteger, AVAuthorizationStatus) {
 // 表明用户尚未选择关于客户端是否可以访问硬件
 AVAuthorizationStatusNotDetermined = 0,
 // 客户端未被授权访问硬件的媒体类型。用户不能改变客户机的状态,可能由于活跃的限制,如家长控制
 AVAuthorizationStatusRestricted,
 // 明确拒绝用户访问硬件支持的媒体类型的客户
 AVAuthorizationStatusDenied,
 // 客户端授权访问硬件支持的媒体类型
 AVAuthorizationStatusAuthorized
 } NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
 */

+(BOOL)isGetCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status!= AVAuthorizationStatusDenied)
    {
        return true;
    }else{
        return  false;
    }
    
}

/**
 typedef NS_ENUM(NSInteger, ALAuthorizationStatus) {
 // 用户还没有关于这个应用程序做出了选择
 ALAuthorizationStatusNotDetermined NS_ENUM_DEPRECATED_IOS(6_0, 9_0) = 0, // User has not yet made a choice with regards to this application
 // 这个应用程序未被授权访问图片数据。用户不能更改该应用程序的状态,可能是由于活动的限制,如家长控制到位。
 ALAuthorizationStatusRestricted NS_ENUM_DEPRECATED_IOS(6_0, 9_0),        // This application is not authorized to access photo data.
 // The user cannot change this application’s status, possibly due to active restrictions
 //  such as parental controls being in place.
 // 用户已经明确否认了这个应用程序访问图片数据
 ALAuthorizationStatusDenied NS_ENUM_DEPRECATED_IOS(6_0, 9_0),            // User has explicitly denied this application access to photos data.
 // 用户授权此应用程序访问图片数据
 ALAuthorizationStatusAuthorized NS_ENUM_DEPRECATED_IOS(6_0, 9_0)        // User has authorized this application to access photos data.
 } NS_DEPRECATED_IOS(6_0, 9_0, "Use PHAuthorizationStatus in the Photos framework instead");
 */

+(BOOL)isGetPhotoPermission {
    BOOL bResult = false;
    if (@available(iOS 8.0, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status != PHAuthorizationStatusDenied)
        {
            bResult = true;
        }
    }
//    else{
//        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
//        if (status != ALAuthorizationStatusDenied)
//        {
//             bResult = true;
//        }
//    }
    
    
    return  bResult;
    
}

@end
