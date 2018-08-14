//
//  OriginFaceViewController.m
//  UnitTestDemo
//
//  Created by 王留根 on 2018/8/13.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import "OriginFaceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "PermissionDetector.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import "DemoPreDefine.h"
#import "CaptureManager.h"
#import "CanvasView.h"
#import "CalculatorTools.h"
#import "UIImage+Extensions.h"
#import "IFlyFaceImage.h"
#import "IFlyFaceResultKeys.h"
#import "YLRecordVideoView.h"
#import "ExtensionHeader.h"

@interface OriginFaceViewController ()<CaptureManagerDelegate,YLRecordVideoChoiceDelegate>
{
    UILabel *alignLabel;
    int number;//
    int takePhotoNumber;
    NSTimer *timer;
    NSInteger timeCount;
    UIImageView *imgView;//动画图片展示
    
    //拍照操作
    AVCaptureStillImageOutput *myStillImageOutput;
    UIView *backView;//照片背景
    UIImageView *imageView;//照片展示
    
    BOOL isCrossBorder;//判断是否越界
    // BOOL isJudgeMouth;//判断张嘴操作完成
    BOOL isShakeHead;//判断摇头操作完成
    
    //嘴角坐标
    int leftX;
    int rightX;
    int lowerY;
    int upperY;
    
    //嘴型的宽高（初始的和后来变化的）
    int mouthWidthF;
    int mouthHeightF;
    int mouthWidth;
    int mouthHeight;
    
    //记录摇头嘴中点的数据
    int bigNumber;
    int smallNumber;
    int firstNumber;
}
@property (nonatomic, retain ) UIView         *previewView;
@property (nonatomic, strong ) UILabel        *textLabel;

@property (nonatomic, retain ) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain ) CaptureManager             *captureManager;

@property (nonatomic, retain ) IFlyFaceDetector           *faceDetector;
@property (nonatomic, strong ) CanvasView                 *viewCanvas;
@property (nonatomic, strong ) UITapGestureRecognizer     *tapGesture;
@property (nonatomic, strong) YLRecordVideoView * recordVideoView;
@property (nonatomic, assign) BOOL recordBegin;

@end

@implementation OriginFaceViewController
@synthesize captureManager;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.recordBegin = false;
    //创建界面
    [self makeUI];
    //创建摄像页面
    [self makeCamera];
    //创建数据
    [self makeNumber];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止摄像
    [self.previewLayer.session stopRunning];
    [self.captureManager removeObserver];
    [self.captureManager.writeManager stopWrite];
    
    
}

-(void)makeNumber
{
    //张嘴数据
    number = 0;
    takePhotoNumber = 0;
    
    mouthWidthF = 0;
    mouthHeightF = 0;
    mouthWidth = 0;
    mouthHeight = 0;
    
    //摇头数据
    bigNumber = 0;
    smallNumber = 0;
    firstNumber = 0;
}

#pragma mark --- 创建UI界面
-(void)makeUI{
    
    self.previewView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/8, ScreenWidth/3, ScreenWidth*3/4, ScreenWidth*3/4)];
    self.previewView.layer.cornerRadius = ScreenWidth*3/8;
    self.previewView.clipsToBounds = true;
    self.previewView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.previewView];
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth)/2 - 100, ScreenWidth * 13 /12 + 10, 200, 30)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.layer.cornerRadius = 15;
    self.textLabel.text = @"请按提示做动作";
    self.textLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.textLabel];
}

#pragma mark --- 创建相机
-(void)makeCamera
{
    self.title = @"人脸识别";
    //adjust the UI for iOS 7
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS9_OR_LATER ){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
    self.view.backgroundColor = [UIColor colorWithHexString: @"f3f4f5"];
    self.previewView.backgroundColor=[UIColor clearColor];
    
    //设置初始化打开识别
    self.faceDetector=[IFlyFaceDetector sharedInstance];
    [self.faceDetector setParameter:@"1" forKey:@"detect"];
    [self.faceDetector setParameter:@"1" forKey:@"align"];
    
    //初始化 CaptureSessionManager
    self.captureManager=[[CaptureManager alloc] init];
    self.captureManager.delegate=self;
    
    self.previewLayer=self.captureManager.previewLayer;
    
    self.captureManager.previewLayer.frame= self.previewView.bounds;
    //self.captureManager.previewLayer.cornerRadius = ScreenWidth/3;
    //self.captureManager.previewLayer.position=self.previewView.center;
    self.captureManager.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.captureManager.previewLayer];
    
    self.viewCanvas = [[CanvasView alloc] initWithFrame:self.captureManager.previewLayer.frame] ;
    [self.previewView addSubview:self.viewCanvas] ;
    self.viewCanvas.center=self.captureManager.previewLayer.position;
    self.viewCanvas.backgroundColor = [UIColor clearColor];
    NSString *str = [NSString stringWithFormat:@"{{%f, %f}, {220, 240}}",(ScreenWidth-220)/2,(ScreenWidth-240)/2+15];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:str forKey:@"RECT_KEY"];
    [dic setObject:@"1" forKey:@"RECT_ORI"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:dic];
    self.viewCanvas.arrFixed = arr;
    self.viewCanvas.hidden = NO;
    
    //建立 AVCaptureStillImageOutput
    myStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *myOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [myStillImageOutput setOutputSettings:myOutputSettings];
    [self.captureManager.session addOutput:myStillImageOutput];
    
    //开始摄像
    [self.captureManager setup];
    [self.captureManager addObserver];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    [self.captureManager observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - 开启识别
- (void) showFaceLandmarksAndFaceRectWithPersonsArray:(NSMutableArray *)arrPersons
{
    
    if (self.viewCanvas.hidden) {
        self.viewCanvas.hidden = NO;
    }
    self.viewCanvas.arrPersons = arrPersons;
    [self.viewCanvas setNeedsDisplay] ;
    
}

#pragma mark --- 关闭识别
- (void) hideFace
{
    if (!self.viewCanvas.hidden) {
        self.viewCanvas.hidden = YES ;
    }
}

#pragma mark --- 脸部框识别
-(NSString*)praseDetect:(NSDictionary* )positionDic OrignImage:(IFlyFaceImage*)faceImg
{
    if(!positionDic){
        return nil;
    }
    
    // 判断摄像头方向
    BOOL isFrontCamera=self.captureManager.videoDeviceInput.device.position==AVCaptureDevicePositionFront;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.previewLayer.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.previewLayer.frame.size.height / faceImg.width;
    
    CGFloat bottom =[[positionDic objectForKey:KCIFlyFaceResultBottom] floatValue];
    CGFloat top=[[positionDic objectForKey:KCIFlyFaceResultTop] floatValue];
    CGFloat left=[[positionDic objectForKey:KCIFlyFaceResultLeft] floatValue];
    CGFloat right=[[positionDic objectForKey:KCIFlyFaceResultRight] floatValue];
    
    float cx = (left+right)/2;
    float cy = (top + bottom)/2;
    float w = right - left;
    float h = bottom - top;
    
    float ncx = cy ;
    float ncy = cx ;
    
    CGRect rectFace = CGRectMake(ncx-w/2 ,ncy-w/2 , w, h);
    
    if(!isFrontCamera){
        rectFace=rSwap(rectFace);
        rectFace=rRotate90(rectFace, faceImg.height, faceImg.width);
    }
    
    //判断位置
    BOOL isNotLocation = [self identifyYourFaceLeft:left right:right top:top bottom:bottom];
    
    if (isNotLocation==YES) {
        return nil;
    }
    
    //NSLog(@"left=%f right=%f top=%f bottom=%f",left,right,top,bottom);
    
    isCrossBorder = NO;
    
    rectFace=rScale(rectFace, widthScaleBy, heightScaleBy);
    
    return NSStringFromCGRect(rectFace);
}

#pragma mark --- 脸部部位识别
-(NSMutableArray*)praseAlign:(NSDictionary* )landmarkDic OrignImage:(IFlyFaceImage*)faceImg
{
    if(!landmarkDic){
        return nil;
    }
    
    // 判断摄像头方向
    BOOL isFrontCamera=self.captureManager.videoDeviceInput.device.position==AVCaptureDevicePositionFront;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.previewLayer.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.previewLayer.frame.size.height / faceImg.width;
    
    NSMutableArray *arrStrPoints = [NSMutableArray array];
    NSEnumerator* keys=[landmarkDic keyEnumerator];
    for(id key in keys){
        id attr=[landmarkDic objectForKey:key];
        if(attr && [attr isKindOfClass:[NSDictionary class]]){
            
            id attr=[landmarkDic objectForKey:key];
            CGFloat x=[[attr objectForKey:KCIFlyFaceResultPointX] floatValue];
            CGFloat y=[[attr objectForKey:KCIFlyFaceResultPointY] floatValue];
            
            CGPoint p = CGPointMake(y,x);
            
            if(!isFrontCamera){
                p=pSwap(p);
                p=pRotate90(p, faceImg.height, faceImg.width);
            }
            
            //判断是否越界
            if (isCrossBorder == YES) {
                [self delateNumber];//清数据
                return nil;
            }
            
            //获取嘴的坐标，判断是否张嘴
            [self identifyYourFaceOpenMouth:key p:p];
            
            //获取鼻尖的坐标，判断是否摇头
            [self identifyYourFaceShakeHead:key p:p];
            
            p=pScale(p, widthScaleBy, heightScaleBy);
            
            [arrStrPoints addObject:NSStringFromCGPoint(p)];
            
        }
    }
    
    return arrStrPoints;
}

#pragma mark --- 脸部识别
-(void)praseTrackResult:(NSString*)result OrignImage:(IFlyFaceImage*)faceImg
{
    if(!result){
        return;
    }
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* faceDic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        resultData=nil;
        if(!faceDic){
            return;
        }
        
        NSString* faceRet=[faceDic objectForKey:KCIFlyFaceResultRet];
        NSArray* faceArray=[faceDic objectForKey:KCIFlyFaceResultFace];
        faceDic=nil;
        
        int ret=0;
        if(faceRet){
            ret=[faceRet intValue];
        }
        //没有检测到人脸或发生错误
        if (ret || !faceArray || [faceArray count]<1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideFace];
            }) ;
            return;
        }
        //        if (!self.recordBegin) {
        //            [self.recordVideoView startRecord];
        //        }
        //        self.recordBegin = true;
        
        //检测到人脸
        NSMutableArray *arrPersons = [NSMutableArray array] ;
        
        for(id faceInArr in faceArray){
            
            if(faceInArr && [faceInArr isKindOfClass:[NSDictionary class]]){
                
                NSDictionary* positionDic=[faceInArr objectForKey:KCIFlyFaceResultPosition];
                NSString* rectString=[self praseDetect:positionDic OrignImage: faceImg];
                positionDic=nil;
                
                NSDictionary* landmarkDic=[faceInArr objectForKey:KCIFlyFaceResultLandmark];
                NSMutableArray* strPoints=[self praseAlign:landmarkDic OrignImage:faceImg];
                landmarkDic=nil;
                
                
                NSMutableDictionary *dicPerson = [NSMutableDictionary dictionary] ;
                if(rectString){
                    [dicPerson setObject:rectString forKey:RECT_KEY];
                }
                if(strPoints){
                    [dicPerson setObject:strPoints forKey:POINTS_KEY];
                }
                
                strPoints=nil;
                
                [dicPerson setObject:@"0" forKey:RECT_ORI];
                [arrPersons addObject:dicPerson] ;
                
                dicPerson=nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showFaceLandmarksAndFaceRectWithPersonsArray:arrPersons];
                });
            }
        }
        faceArray=nil;
    }
    @catch (NSException *exception) {
        // NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
    }
}

#pragma mark - CaptureManagerDelegate
-(void)onOutputFaceImage:(IFlyFaceImage*)faceImg
{
    NSString* strResult=[self.faceDetector trackFrame:faceImg.data withWidth:faceImg.width height:faceImg.height direction:(int)faceImg.direction];
    //NSLog(@"result:%@",strResult);
    
    //此处清理图片数据，以防止因为不必要的图片数据的反复传递造成的内存卷积占用。
    faceImg.data=nil;
    /* 直接调用方法的方式有两种：performSelector:withObject: 和 NSInvocation。
     * NSInvocation是一个消息调用类，它包含了所有OC消息的成分：target、selector、参数以及返回值。NSInvocation可以将消息转换成一个对象，消息的每一个参数能够直接设定，而且当一个NSInvocation对象调度时返回值是可以自己设定的。一个NSInvocation对象能够重复的调度不同的目标(target)，而且它的selector也能够设置为另外一个方法签名。NSInvocation遵守NSCoding协议，但是仅支持NSPortCoder编码，不支持归档型操作
     *
     *
     */
    //// 通过NSMethodSignature对象创建NSInvocation对象，NSMethodSignature为方法签名类
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(praseTrackResult:OrignImage:)];
    if (!sig) return;
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    //// 设置消息调用者，注意：target最好不要是局部变量
    [invocation setTarget:self];
    //// 设置要调用的消息
    [invocation setSelector:@selector(praseTrackResult:OrignImage:)];
    //// 设置消息参数. 参数必须从第2个索引开始，因为前两个已经被target和selector使用
    [invocation setArgument:&strResult atIndex:2];
    [invocation setArgument:&faceImg atIndex:3];
    //// 保留参数，它会将传入的所有参数以及target都retain一遍
    [invocation retainArguments];
    /// 发送消息，即执行方法
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil  waitUntilDone:NO];
    faceImg=nil;
    
    // 5. 获取方法返回值
    //    NSNumber *num = nil;
    //    [invocation getReturnValue:&num];
    //    NSLog(@"最大数为：%@",num);
}

#pragma mark --- 判断位置
-(BOOL)identifyYourFaceLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom
{
    //    //判断位置
    //    if (right - left < 230 || bottom - top < 250) {
    //        self.textLabel.text = @"太远了...";
    //        [self delateNumber];//清数据
    //        isCrossBorder = YES;
    //        return YES;
    //    }else if (right - left > 320 || bottom - top > 320) {
    //        self.textLabel.text = @"太近了...";
    //        [self delateNumber];//清数据
    //        isCrossBorder = YES;
    //        return YES;
    //    }else{
    //
    //    }
    if (takePhotoNumber < 2) {
        self.textLabel.text = @"请重复张嘴动作...";
        //[self tomAnimationWithName:@"openMouth" count:2];
#pragma mark --- 限定脸部位置为中间位置
        //        if (left < 100 || top < 100 || right > 460 || bottom > 400) {
        //            isCrossBorder = YES;
        //            isJudgeMouth = NO;
        //            self.textLabel.text = @"调整下位置先...";
        //            [self delateNumber];//清数据
        //            return YES;
        //        }
    }
    //        else if (isJudgeMouth == YES && isShakeHead != YES) {
    //            self.textLabel.text = @"请重复摇头动作...";
    //            [self tomAnimationWithName:@"shakeHead" count:4];
    //            number = 0;
    //        }
    else if(takePhotoNumber == 2){
        takePhotoNumber += 1;
        NSLog(@"=======");
        [self.captureManager stopRecord];
    }
    isCrossBorder = NO;
    return NO;
}

#pragma mark --- 判断是否张嘴
-(void)identifyYourFaceOpenMouth:(NSString *)key p:(CGPoint )p
{
    if ([key isEqualToString:@"mouth_upper_lip_top"]) {
        upperY = p.y;
    }
    if ([key isEqualToString:@"mouth_lower_lip_bottom"]) {
        lowerY = p.y;
    }
    if ([key isEqualToString:@"mouth_left_corner"]) {
        leftX = p.x;
    }
    if ([key isEqualToString:@"mouth_right_corner"]) {
        rightX = p.x;
    }
    if (rightX && leftX && upperY && lowerY && takePhotoNumber < 2) {
        //  NSLog(@"================= number:%@ ====================",@(number));
        number ++;
        if (number == 1 || number == 200 || number == 400 || number == 600 || number == 800 || number == 1000 || number == 1200 || number == 1400  || number == 1600) {
            //延时操作
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            mouthWidthF = rightX - leftX < 0 ? abs(rightX - leftX) : rightX - leftX;
            mouthHeightF = lowerY - upperY < 0 ? abs(lowerY - upperY) : lowerY - upperY;
            //NSLog(@"%d,%d",mouthWidthF,mouthHeightF);
            //            });
        }else if (number > 1700) {
            //            NSLog(@"================= 清除数据 ====================");
            [self delateNumber];//时间过长时重新清除数据
            //[self tomAnimationWithName:@"openMouth" count:2];
        }
        
        mouthWidth = rightX - leftX < 0 ? abs(rightX - leftX) : rightX - leftX;
        mouthHeight = lowerY - upperY < 0 ? abs(lowerY - upperY) : lowerY - upperY;
        //NSLog(@"%d,%d",mouthWidth,mouthHeight);
        //NSLog(@"张嘴前：width=%d，height=%d",mouthWidthF - mouthWidth,mouthHeight - mouthHeightF);
        if (mouthWidth && mouthWidthF) {
            //张嘴验证完毕
            if (mouthHeight - mouthHeightF >= 20 && mouthWidthF - mouthWidth >= 15) {
                takePhotoNumber += 1;
                //                mouthWidthF = 0;
                //                mouthHeightF = 0;
                // NSLog(@"================= takePhotoNumber：%@ ====================",@(takePhotoNumber));
            }
        }
    }
}

#pragma mark --- 判断是否摇头
-(void)identifyYourFaceShakeHead:(NSString *)key p:(CGPoint )p
{
    if ([key isEqualToString:@"mouth_middle"] && takePhotoNumber == 2) {
        
        if (bigNumber == 0 ) {
            firstNumber = p.x;
            bigNumber = p.x;
            smallNumber = p.x;
        }else if (p.x > bigNumber) {
            bigNumber = p.x;
        }else if (p.x < smallNumber) {
            smallNumber = p.x;
        }
        //摇头验证完毕
        if (bigNumber - smallNumber > 60) {
            isShakeHead = YES;
            [self delateNumber];//清数据
        }
    }
}





#pragma mark --- 清掉对应的数
-(void)delateNumber
{
    number = 0;
    takePhotoNumber = 0;
    
    mouthWidthF = 0;
    mouthHeightF = 0;
    mouthWidth = 0;
    mouthHeight = 0;
    
    smallNumber = 0;
    bigNumber = 0;
    firstNumber = 0;
    //
    //    imgView.animationImages = nil;
    //    imgView.image = [UIImage imageNamed:@"shakeHead0"];
}


#pragma mark --- 创建button公共方法
/**使用示例:[self buttonWithTitle:@"点 击" frame:CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 40)/3, 150, 40) action:@selector(didClickButton) AddView:self.view];*/
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [view addSubview:button];
    return button;
}


-(void)dealloc
{
    self.captureManager=nil;
    self.viewCanvas=nil;
    [self.previewView removeGestureRecognizer:self.tapGesture];
    self.tapGesture=nil;
}

-(void)choiceVideoWith:(NSString *)path {
    NSLog(@"path:%@",path);
}
-(void)onOutputSourceString:(NSString *)sourceString {
    NSLog(@"结束录制： %@",sourceString);
    [self calculationFileSize: sourceString];

}

//获取文件
- (NSData *)getFileData:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}

-(void)timeOverForRecord{
    [self delateNumber];
}

-(void)calculationFileSize:(NSString * )path {
    unsigned long long fileLength = 0;
    NSNumber *fileSize;
    NSString *videoSizeString;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
        fileLength = [fileSize unsignedLongLongValue];
    }
    if (fileLength < 1024) {
        videoSizeString = [NSString stringWithFormat:@"%.1lluB",fileLength];
    }else if (fileLength >1024 && fileLength < 1024*1024){
        videoSizeString = [NSString stringWithFormat:@"%.1lluKB",fileLength/1024];
    }else if (fileLength >1024*1024 && fileLength < 1024*1024 *1024){
        videoSizeString = [NSString stringWithFormat:@"%.1lluMB",fileLength/(1024*1024)];
    }
    NSLog(@"文件大小为：%@",videoSizeString);
    
}
@end
