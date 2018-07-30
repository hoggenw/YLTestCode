//
//  YLRecordVideoView.m
//  UnitTestDemo
//
//  Created by 王留根 on 2018/7/30.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import "YLRecordVideoView.h"
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>





@interface YLRecordVideoView ()<AVCaptureFileOutputRecordingDelegate,YLRecordVideoControlDelegate>

@property (nonatomic, copy) NSString *sessionPreset;
@property (nonatomic, strong) NSNumber *videoWidthKey;
@property (nonatomic, strong) NSNumber *videoHightKey;
@property (nonatomic, assign) CGFloat totalSeconds;
@property (nonatomic, assign) int32_t framesPerSecond;
@property (nonatomic, copy) NSString *videoType;
@property (nonatomic, assign) AVCameraStatues setupResult;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureDevice *audioDevice;
@property (nonatomic, strong) AVCaptureFileOutput *fileOutput;
@property (nonatomic, copy) NSString *customVideoPath;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * videoLayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;


@end

@implementation YLRecordVideoView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelfData];
        [self initUI];
        [self setupCaptureSession];
    }
    return self;
}

-(void)setupCaptureSession {
    [self.captureSession beginConfiguration];
    self.captureSession.sessionPreset = self.sessionPreset;
     NSError *error = nil;
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:&error];
    NSError *error2 = nil;
    AVCaptureDeviceInput *dudioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:&error2];
    if ([self.captureSession canAddInput: videoDeviceInput]) {
        [self.captureSession addInput: videoDeviceInput];
    }
    if ([self.captureSession canAddInput: dudioDeviceInput]) {
        [self.captureSession addInput: dudioDeviceInput];
    }
    CMTime maxDuration = CMTimeMake(self.totalSeconds, self.framesPerSecond);
    self.fileOutput.maxRecordedDuration = maxDuration;
    if ( [self.captureSession canAddOutput: self.fileOutput]) {
        [self.captureSession addOutput: self.fileOutput];
    }
    self.captureSession.sessionPreset = self.sessionPreset;
     __weak YLRecordVideoView *weakSelf = self;
    [self.captureSession commitConfiguration];
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:{
            self.setupResult = Success;
            [self setupAssetWriter];
            break;
        }
        case AVAuthorizationStatusNotDetermined:{
            dispatch_suspend(self.sessionQueue);
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (!granted) {
                    weakSelf.setupResult = UnAuthorized;
                }else{
                     weakSelf.setupResult = Success;
                }
                dispatch_resume(weakSelf.sessionQueue);
                [weakSelf setupAssetWriter];
                
            }];
            break;
        }
        default:
            self.setupResult = UnAuthorized;
            break;
    }
    
}
-(void)setupAssetWriter {
    __weak YLRecordVideoView *weakSelf = self;
    dispatch_async(self.sessionQueue, ^{
        if (!self.setupResult) {
            return ;
        }
        switch (self.setupResult) {
            case Success:{
                [weakSelf.captureSession startRunning];
                AVAssetWriter * assetWriter;
                assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:weakSelf.customVideoPath] fileType:weakSelf.videoType error:nil];
                NSDictionary * videoCompressionProperties = @{AVVideoAverageBitRateKey: @(1000 * 1024),
                                                              AVVideoProfileLevelKey: AVVideoProfileLevelH264Main30,
                                                              AVVideoMaxKeyFrameIntervalKey:@(40)};
                NSDictionary * videoSettings = @{AVVideoCodecKey : AVVideoCodecH264,
                                                 AVVideoWidthKey:weakSelf.videoWidthKey,
                                                 AVVideoHeightKey:weakSelf.videoHightKey,
                                                 AVVideoCompressionPropertiesKey:videoCompressionProperties};
                AVAssetWriterInput *videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings: videoSettings];
                if ([assetWriter canAddInput:videoWriterInput]) {
                    [assetWriter addInput: videoWriterInput];
                }
                NSDictionary *audioInputSetting = [self configAudioInput];
                AVAssetWriterInput * audioWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioInputSetting];
                audioWriterInput.expectsMediaDataInRealTime = true;
                if ([assetWriter canAddInput: audioWriterInput]) {
                    [assetWriter addInput: audioWriterInput];
                }
                
               break;
            }
            case UnAuthorized:{
                //设置权限
                break;
            }
            case Failed:{
                break;
            }
                
                
                
            default:
                break;
        }
        
    });
    
}
- (NSDictionary *)configAudioInput
{
    AudioChannelLayout channelLayout;
    bzero( &channelLayout, sizeof(channelLayout));   //初始化音频通道
    
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;  //设置为单通道模式
    
    
    NSData *channelLayoutData = [NSData dataWithBytes:&channelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
    NSDictionary *audioInputSetting = @{
                                        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                        AVSampleRateKey: @(44100),
                                        AVEncoderBitRateKey: @(64000),
                                        AVChannelLayoutKey:channelLayoutData
                                        };
    return audioInputSetting;
}


-(void)initUI {
    self.videoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: self.captureSession];
    self.videoLayer.frame = self.bounds;
    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.videoLayer pointForCaptureDevicePointOfInterest: CGPointMake(0, 0)];
    [self.layer addSublayer: self.videoLayer];
    
    self.playerLayer = [[AVPlayerLayer alloc] init];
    self.playerLayer.frame = self.bounds;
    self.playerLayer.hidden = true;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer: self.playerLayer];
    
    self.previewButton = [self buttonWithTitle:@"预览" frame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 30, [UIScreen mainScreen].bounds.size.height/2 - 30, 60, 60) action:@selector(previewCaptureVideo) AddView:self];
    self.previewButton.hidden = true;
    
    YLRecordVideoView *recordView = [[YLRecordVideoView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width, 100)];
    recordView.delegate = self;
    recordView.totalSeconds = 10;
    [self addSubview: recordView];

    
}

-(void)initSelfData {
    self.videoQuality = NormalQuality;
    self.sessionPreset = AVCaptureSessionPreset640x480;
    self.videoWidthKey = @(480);
    self.videoHightKey = @(640);
    self.totalSeconds = 10.0;
    self.framesPerSecond = 30;
    self.videoType = AVFileTypeMPEG4;
    self.sessionQueue = dispatch_queue_create("VideoCaptureQueue", DISPATCH_QUEUE_SERIAL);
    self.captureSession = [[AVCaptureSession alloc] init];
    self.videoDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].firstObject;
    self.audioDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].firstObject;
    self.fileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    
    
}

-(NSString *)recordVideoPath{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , true).firstObject;
    NSString * name = [self randomUpperCaseString: 32];
    NSString * pathString = [NSString stringWithFormat:@"%@/%@.mp4", documentsPath,name];
    return  pathString;
}

-(NSString *)randomUpperCaseString:(NSInteger )length{
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < length;  i++) {
        NSInteger randomNumber = arc4random()%26 + 65;
        NSString * randomChar = [NSString stringWithFormat:@"%c",randomNumber];
        [resultString appendString: randomChar];
        
    }
    NSLog(@"随机文件名：%@",resultString);
    return resultString;
}
                                  

-(void)setVideoQuality:(YLVideoQuality)videoQuality {
    _videoQuality = videoQuality;
    switch (videoQuality) {
        case NormalQuality:{
            self.sessionPreset = AVCaptureSessionPreset640x480;
            self.videoWidthKey = @(480);
            self.videoHightKey = @(640);
            break;
        }
        case LowQuality:{
            self.sessionPreset = AVCaptureSessionPreset352x288;
            self.videoWidthKey = @(288);
            self.videoHightKey = @(352);
            break;
        }
        case HighQuality:{
            self.sessionPreset = AVCaptureSessionPreset1280x720;
            self.videoWidthKey = @(720);
            self.videoHightKey = @(1280);
            break;
        }
        default:
            break;
    }
    
}

-(NSString *)customVideoPath {
    if (_customVideoPath == nil) {
        _customVideoPath = [self recordVideoPath];
    }
    return _customVideoPath;
}
#pragma mark - 操作方法

-(void)startRecord {
     NSString * outputFilePath = self.customVideoPath;
    NSURL *outputURL = [NSURL fileURLWithPath:outputFilePath];
    [self.fileOutput startRecordingToOutputFileURL: outputURL recordingDelegate: self];
    NSLog(@"开始录像");
}

-(void)stopRecord {
    [self.fileOutput stopRecording];
    [self calculationFileSize: self.customVideoPath];
    NSLog(@"结束录像");
}
-(void)restartRecord {
    self.videoLayer.hidden = false;
    self.playerLayer.hidden = true;
    [self deleteFile: self.customVideoPath];
    [self startRecord];

}

-(void)previewCaptureVideo {
    NSLog(@"预览录制");
    self.previewButton.hidden = true;
    NSString * outputFilePath = self.customVideoPath;
    NSURL *outputURL = [NSURL fileURLWithPath:outputFilePath];
    AVPlayerItem * playItem = [[AVPlayerItem alloc] initWithURL: outputURL];
    self.playerLayer.player = [[AVPlayer alloc] initWithPlayerItem: playItem];
    [self.playerLayer.player play];
}

- (void)deleteFile:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:path error: nil]) {
            NSLog(@"删除文件%@成功",path);
            self.customVideoPath = nil;
        }
    }
}

-(void)preparePreview {
    self.videoLayer.hidden = true;
    self.playerLayer.hidden = false;
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

-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds =true;
    [view addSubview:button];
    return button;
}


#pragma mark -delegate

-(void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    [self preparePreview];
    [self calculationFileSize: self.customVideoPath];
}


#pragma mark- YLRecordVideoControlDelegate

-(void)startRecordDelegate {
    [self startRecord];
}

-(void)restartRecordDelegate {
    [self restartRecordDelegate];
}
-(void)cancelRecordDelegate {
    [self stopRecord];
    [self deleteFile: self.customVideoPath];
    [self.playerLayer.player pause];
}

-(void)stopRecordDelegate{
    [self stopRecord];
}

-(void)choiceVideoDelegate {
    [self calculationFileSize: self.customVideoPath];
     [self.playerLayer.player pause];
    if (self.delegate != nil) {
        [self.delegate choiceVideoWith: self.customVideoPath];
    }
}


@end

