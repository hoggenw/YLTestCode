//
//  ViewController.m
//  UnitTestDemo
//
//  Created by 王留根 on 2017/12/12.
//  Copyright © 2017年 王留根. All rights reserved.
//

#import "ViewController.h"
#import "FaceStreamDetectorViewController.h"
#import "FMWriteVideoController.h"
#import "RecordVideoViewController.h"

@interface ViewController ()<FaceDetectorDelegate>
{
    UIImageView *imgView;
}
@property (nonatomic, strong, readwrite) NSString *videoUrl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self buttonWithTitle:@"人脸识别" frame:CGRectMake(100, 50, 150, 30) action:@selector(pushToFaceStreamDetectorVC) AddView:self.view];
    [self buttonWithTitle:@"视频录制" frame:CGRectMake(100, 90, 150, 30) action:@selector(pushToRecordVideoViewController) AddView:self.view];
    [self buttonWithTitle:@"测试方式1" frame:CGRectMake(100, 130, 150, 30) action:@selector(toFMWriteVideoController) AddView:self.view];
    
     [self buttonWithTitle:@"有数据测试" frame:CGRectMake(100, 400, 150, 30) action:@selector(dataTest) AddView:self.view];
    
//    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 200, self.view.frame.size.width-100, 200)];
//    imgView.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:imgView];
//
}

-(void)sendFaceImage:(UIImage *)faceImage
{
    imgView.frame = CGRectMake(50, 150, self.view.frame.size.width-100, (self.view.frame.size.width-100)/faceImage.size.width*faceImage.size.height);
    imgView.image = faceImage;
}
-(void)sendSourceString:(NSString *)sourceString{
    self.videoUrl = sourceString;
    NSData * data = [self getFileData: sourceString];
    NSLog(@"data.length : %@",@(data.length));

}

//获取文件
- (NSData *)getFileData:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}

-(void)dataTest {
     NSLog(@"资源路径：%@",self.videoUrl);
    RecordVideoViewController *faceVC = [[RecordVideoViewController alloc]init];
    faceVC.videoUrl = self.videoUrl;
    [self.navigationController pushViewController:faceVC animated:YES];
}

-(void)pushToRecordVideoViewController {
    RecordVideoViewController *faceVC = [[RecordVideoViewController alloc]init];
    [self.navigationController pushViewController:faceVC animated:YES];
}

-(void)pushToFaceStreamDetectorVC
{
    FaceStreamDetectorViewController *faceVC = [[FaceStreamDetectorViewController alloc]init];
    faceVC.faceDelegate = self;
    [self.navigationController pushViewController:faceVC animated:YES];
}

-(void)toFMWriteVideoController{
    FMWriteVideoController *writeVC = [[FMWriteVideoController alloc] init];
    UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:writeVC];
    [self presentViewController:NAV animated:YES completion:nil];
}

#pragma mark --- 创建button公共方法
/**使用示例:[self buttonWithTitle:@"点 击" frame:CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 40)/3, 150, 40) action:@selector(didClickButton) AddView:self.view];*/
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [UIColor colorWithRed:0.601 green:0.596 blue:0.906 alpha:1.000];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [view addSubview:button];
    return button;
}
-(int)getMaxNUmber:(int)number {
    return number;
}

@end
