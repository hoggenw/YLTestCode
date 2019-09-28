//
//  YLUMengHelper.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/26.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import Foundation

public struct YLUMengHelper {
    
    static func UMSocialStart() {
        UMConfigure.initWithAppkey(YLThirdSDKUMSocialAppkey, channel: "App Store");
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx89e14834538c5665", appSecret: "314873cade5678f73210b8179661948b", redirectURL: "https://hoggen.top");
        
        #if DEBUG
        UMSocialManager.default()?.openLog(true);
        #endif

    }
    
    static func shareTitle(title:String, subTitle:String,thumbImage:String, shareURL:String) {
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) in
            shareWebPageToPlatformType(platformType: platformType, title: title, subTitle: subTitle, thumbImage: thumbImage, shareURL: shareURL);
        }
    }
    
    static func shareWebPageToPlatformType(platformType:UMSocialPlatformType,title:String, subTitle:String,thumbImage:String, shareURL:String) {
        let messageObject = UMSocialMessageObject();
        let shareObject = UMShareWebpageObject.shareObject(withTitle: title, descr: subTitle, thumImage: thumbImage);
        shareObject?.webpageUrl = shareURL;
        messageObject.shareObject = shareObject;
        
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: nil, completion: { (data, error) in
            if let _ = error {
                print("\(String(describing: error))");
            }else{
                if ((data as? UMSocialShareResponse) != nil){
                    let resp: UMSocialShareResponse = data as! UMSocialShareResponse;
                    print("response message is \(String(describing: resp.message))");
                    
                }
            }
        })
        
    }
    
    
    func getUserInfoForPlatform(platformType:UMSocialPlatformType, completion: @escaping (_ result:UMSocialUserInfoResponse,_ error:NSError?) -> Void)  {
        UMSocialManager.default()?.getUserInfo(with: platformType, currentViewController: nil, completion: { (result, error) in
            let resp: UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse;
            
            // 授权数据
            NSLog(" uid: %@", resp.uid);
            NSLog(" openid: %@", resp.openid);
            NSLog(" accessToken: %@", resp.accessToken);
            NSLog(" refreshToken: %@", resp.refreshToken);
            // 用户数据
            NSLog(" name: %@", resp.name);
            NSLog(" iconurl: %@", resp.iconurl);
            NSLog(" gender: %@", resp.gender);
            completion(resp,error as NSError?);
        });
    }
    
    
}
