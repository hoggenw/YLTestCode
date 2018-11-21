//
//  YLScanViewController.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLScanViewController.h"

@interface YLScanViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) YLScanViewSetting *scanObj;

@end

@implementation YLScanViewController



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scanStyle = [YLScanViewSytle new];
        self.isOpenInterestRect = false;
        self.btnFlash = [UIButton new];
         self.buttonBcak = [UIButton new];
         self.buttonPhone = [UIButton new];
         self.isNeedCodeImage = false;
         self.ifShow = false;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setHidden: true];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self drawScanView];
}

-(void)drawScanView {
    if (_qRScanView == nil ){
        _qRScanView = [[YLScanView alloc] initWithFrame:self.view.frame scanViewStyle:_scanStyle];
        [self.view addSubview: _qRScanView];
    }
    [_qRScanView deviceStartReadying: @"相机启动中..."];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startScan];
    [self initialBottomView];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_qRScanView stopScanAnimtion];
    [_scanObj stop];
}


-(void)initialBottomView {
    CGSize size = CGSizeMake( 65,  87);
    _btnFlash.bounds = CGRectMake(0,  0,  size.width,  size.height);
    _btnFlash.center = CGPointMake(self.view.frame.size.width - 40, self.view.frame.size.height - 80);
    
    [_btnFlash setImage:[YLScanViewSetting imageFromBundleWithName:@"qrcode_scan_btn_flash_nor@2x"] forState:UIControlStateNormal];
    [_btnFlash setImage:[YLScanViewSetting imageFromBundleWithName:@"qrcode_scan_btn_flash_down@2x"] forState:UIControlStateSelected];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash:) forControlEvents:UIControlEventTouchUpInside];

    
    CGSize sizeBack = CGSizeMake( 50,  50);
    _buttonBcak.bounds = CGRectMake(0,  0,  sizeBack.width,  sizeBack.height);
    _buttonBcak.center = CGPointMake(40, 50);
    
    _buttonBcak.layer.cornerRadius = 25;
    _buttonBcak.clipsToBounds = true;
    _buttonBcak.backgroundColor = UIColor.blackColor;
    _buttonBcak.alpha = 0.5;
    [_buttonBcak setImage:[YLScanViewSetting imageFromBundleWithName:@"qr_vc_left"] forState:UIControlStateNormal];
    [_buttonBcak addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _buttonBcak];
    [self.view addSubview: _btnFlash];
    
    
    CGSize sizePhone = CGSizeMake( 65,  87);
    _buttonPhone.bounds = CGRectMake(0,  0,  sizePhone.width,  sizePhone.height);
    _buttonPhone.center = CGPointMake(40, self.view.frame.size.height - 80);
    
    _buttonPhone.clipsToBounds = true;
    _buttonPhone.backgroundColor = UIColor.clearColor;
     [_buttonPhone setImage:[YLScanViewSetting imageFromBundleWithName:@"qrcode_scan_btn_photo_down"] forState:UIControlStateNormal];
     [_buttonPhone addTarget:self action:@selector(openPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonPhone];
}

-(void)openPhotoAlbum {
    if(![YLPhonePermissions isGetPhotoPermission])
    {
        [self showMsg:@"提示" message:@"没有相册权限，请到设置->隐私中开启本程序相册权限"];
       
    }
    
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.sourceType = PHAssetSourceTypeUserLibrary;
    picker.delegate = self;
    picker.allowsEditing = true;
    [self presentViewController:picker animated:true completion:nil];
}

-(void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated: true];
}
-(void)openOrCloseFlash:(UIButton *)sender {
    [_scanObj changeTorch];
    sender.selected = !sender.selected;
}
-(void)startScan {
    if(![YLPhonePermissions isGetCameraPermission]) {
        [self showMsg:@"提示" message:@"没有相机权限，请到设置->隐私中开启本程序相机权限"];
        return;
    }
    
    if (_scanObj == nil) {
        CGRect cropRect = CGRectZero;
        if (_isOpenInterestRect) {
            cropRect = [YLScanView getScanRectWithPreview:self.view style:_scanStyle];
            
        }
        
        //识别各种码，
        //let arrayCode = LBXScanWrapper.defaultMetaDataObjectTypes()
        
        //指定识别几种码
        if (_arrayCodeType == nil){
            _arrayCodeType = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code];
        }
        
        _scanObj = [[YLScanViewSetting alloc] initWith:self.view objType:_arrayCodeType isCaptureImg:_isNeedCodeImage cropRect:cropRect success:^(NSMutableArray<YLScanResult *> * arrayResult) {
            [self.qRScanView stopScanAnimtion];
            [self handleCodeResult: arrayResult];
        }];
        
    }
    
    //结束相机等待提示
    [_qRScanView deviceStopReadying];
    
    //开始扫描动画
    [_qRScanView startScanAnimation];
    
    //相机运行
    [_scanObj start];
    
}

-(void)handleCodeResult:(NSMutableArray<YLScanResult *> *)arrayResult {
    YLScanResult * result = arrayResult.firstObject;
    if (_delegate != nil) {
        [_delegate scanViewControllerSuccessWith: result];
    }
    [self.navigationController popViewControllerAnimated: true];
}

-(void)showMsg:(NSString *)title  message:(NSString *)message  {
    if (@available(iOS 8.0, *)) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startScan];
        }];
       
        [alertController addAction: alertAction];
        [self presentViewController:alertController animated: true completion:nil];
     
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated: true completion: nil];
    UIImage * image = (UIImage *) info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }else{
        NSArray<YLScanResult *> * arrayResult = [YLScanViewSetting recognizeQRImage: image];
        if (arrayResult.count > 0) {
            [self handleCodeResult: [arrayResult mutableCopy]];
            return;
        }
    }
    [self showMsg:@"" message:@"识别失败"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
