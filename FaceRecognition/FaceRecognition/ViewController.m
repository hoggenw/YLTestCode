//
//  ViewController.m
//  FaceRecognition
//
//  Created by 王留根 on 2018/8/2.
//  Copyright © 2018年 hoggenWang.com. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "PermissionDetector.h"
#import "DemoPreDefine.h"
#import "CaptureManager.h"
#import "ExtensionHeader.h"

@interface ViewController ()<CaptureManagerDelegate,YLRecordVideoChoiceDelegate>
{
    UILabel *alignLabel;
    int number;//
    int takePhotoNumber;
    NSTimer *timer;
    NSInteger timeCount;
    UIImageView *imgView;//动画图片展示
    
    //拍照操作
   // AVCaptureStillImageOutput *myStillImageOutput;
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

//@property (nonatomic, retain ) IFlyFaceDetector           *faceDetector;
//@property (nonatomic, strong ) CanvasView                 *viewCanvas;
@property (nonatomic, strong ) UITapGestureRecognizer     *tapGesture;
@property (nonatomic, assign) BOOL recordBegin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.recordBegin = false;
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
-(void)makeUI
{
    
    //    self.recordVideoView = [[YLRecordVideoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    //    self.recordVideoView.delegate = self;
    //    [self.view addSubview:self.recordVideoView];
    
    self.previewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.previewView];
//
//    //提示框
//    imgView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-ScreenHeight/6+10)/2, CGRectGetMaxY(self.previewView.frame)+15, ScreenHeight/6-10, ScreenHeight/6-10)];
//    [self.view addSubview:imgView];
//
//    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-150)/2, CGRectGetMaxY(imgView.frame)+10, 150, 30)];
//    self.textLabel.textAlignment = NSTextAlignmentCenter;
//    self.textLabel.layer.cornerRadius = 15;
//    self.textLabel.text = @"请按提示做动作";
//    self.textLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.textLabel];
//
//    //背景View
//    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
//    backView.backgroundColor = [UIColor lightGrayColor];
//
//    //图片放置View
//    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenWidth*4/3)];
//    [backView addSubview:imageView];
    //
    //    //button上传图片
    //    [self buttonWithTitle:@"上传图片" frame:CGRectMake(ScreenWidth/2-150, CGRectGetMaxY(imageView.frame)+10, 100, 30) action:@selector(didClickUpPhoto) AddView:backView];
    //
    //    //重拍图片按钮
    //    [self buttonWithTitle:@"重拍" frame:CGRectMake(ScreenWidth/2+50, CGRectGetMaxY(imageView.frame)+10, 100, 30) action:@selector(didClickPhotoAgain) AddView:backView];
    
    
    
    
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
    
    self.view.backgroundColor=[UIColor blackColor];
    self.previewView.backgroundColor=[UIColor clearColor];
    
    //设置初始化打开识别
//    self.faceDetector=[IFlyFaceDetector sharedInstance];
//    [self.faceDetector setParameter:@"1" forKey:@"detect"];
//    [self.faceDetector setParameter:@"1" forKey:@"align"];
    
    //初始化 CaptureSessionManager
    self.captureManager=[[CaptureManager alloc] init];
    self.captureManager.delegate=self;
    
    self.previewLayer=self.captureManager.previewLayer;
    
    self.captureManager.previewLayer.frame= self.previewView.frame;
    self.captureManager.previewLayer.position=self.previewView.center;
    self.captureManager.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.captureManager.previewLayer];
    
//    self.viewCanvas = [[CanvasView alloc] initWithFrame:self.captureManager.previewLayer.frame] ;
//    [self.previewView addSubview:self.viewCanvas] ;
//    self.viewCanvas.center=self.captureManager.previewLayer.position;
//    self.viewCanvas.backgroundColor = [UIColor clearColor];
//    NSString *str = [NSString stringWithFormat:@"{{%f, %f}, {220, 240}}",(ScreenWidth-220)/2,(ScreenWidth-240)/2+15];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:str forKey:@"RECT_KEY"];
//    [dic setObject:@"1" forKey:@"RECT_ORI"];
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    [arr addObject:dic];
//    self.viewCanvas.arrFixed = arr;
//    self.viewCanvas.hidden = NO;
//    
//    //建立 AVCaptureStillImageOutput
//    myStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//    NSDictionary *myOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
//    [myStillImageOutput setOutputSettings:myOutputSettings];
//    [self.captureManager.session addOutput:myStillImageOutput];
    
    //开始摄像
    [self.captureManager setup];
    [self.captureManager addObserver];
}

-(void)onOutputSourceString:(NSString *)SourceString{
    
}
#pragma mark - CaptureManagerDelegate
-(void)onOutputFaceImage:(UIImage *)faceImg
{
    //NSLog(@"%@===%@",faceImg,NSStringFromCGSize( faceImg.size));
    CIImage * ciiimage = [CIImage imageWithCGImage: faceImg.CGImage];
    //2.设置人脸识别精度
    NSDictionary* opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIDetector * detector = [CIDetector detectorOfType:CIFeatureTypeFace context:nil options:opts];
    NSArray *features = [detector featuresInImage: ciiimage];
    NSLog(@"(features.count : %@",@(features.count));
    
    [self.previewView removeAllSubViews];
    //5.分析人脸识别数据
    for (CIFaceFeature *faceFeature in features){
        
        //注意坐标的换算，CIFaceFeature计算出来的坐标的坐标系的Y轴与iOS的Y轴是相反的,需要自行处理
        
        // 标出脸部
        CGFloat faceWidth = faceFeature.bounds.size.width;
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        faceView.frame = CGRectMake(faceView.frame.origin.x, self.previewView.bounds.size.height-faceView.frame.origin.y - faceView.bounds.size.height, faceView.frame.size.width, faceView.frame.size.height);
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        [self.previewView addSubview:faceView];
        // 标出左眼
//        if(faceFeature.hasLeftEyePosition) {
//            UIView* leftEyeView = [[UIView alloc] initWithFrame:
//                                   CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15,
//                                              self.imageView.bounds.size.height-(faceFeature.leftEyePosition.y-faceWidth*0.15)-faceWidth*0.3, faceWidth*0.3, faceWidth*0.3)];
//            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//            //            [leftEyeView setCenter:faceFeature.leftEyePosition];
//            leftEyeView.layer.cornerRadius = faceWidth*0.15;
//            [self.imageView  addSubview:leftEyeView];
//        }
//        // 标出右眼
//        if(faceFeature.hasRightEyePosition) {
//            UIView* leftEye = [[UIView alloc] initWithFrame:
//                               CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15,
//                                          self.imageView.bounds.size.height-(faceFeature.rightEyePosition.y-faceWidth*0.15)-faceWidth*0.3, faceWidth*0.3, faceWidth*0.3)];
//            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//            leftEye.layer.cornerRadius = faceWidth*0.15;
//            [self.imageView  addSubview:leftEye];
//        }
//        // 标出嘴部
//        if(faceFeature.hasMouthPosition) {
//            UIView* mouth = [[UIView alloc] initWithFrame:
//                             CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2,
//                                        self.imageView.bounds.size.height-(faceFeature.mouthPosition.y-faceWidth*0.2)-faceWidth*0.4, faceWidth*0.4, faceWidth*0.4)];
//            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
//            
//            mouth.layer.cornerRadius = faceWidth*0.2;
//            [self.imageView  addSubview:mouth];
//        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
