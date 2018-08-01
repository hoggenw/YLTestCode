//
//  FaceStreamDetectorViewController.h
//  UnitTestDemo
//
//  Created by 王留根 on 2018/7/27.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol FaceDetectorDelegate <NSObject>

-(void)sendFaceImage:(UIImage *)faceImage; //上传图片成功
-(void)sendSourceString:(NSString *)sourceString; //上传图片成功
-(void)sendFaceImageError; //上传图片失败

@end
@interface FaceStreamDetectorViewController : UIViewController

@property (assign,nonatomic) id<FaceDetectorDelegate> faceDelegate;

@end
