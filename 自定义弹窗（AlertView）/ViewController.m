//
//  ViewController.m
//  自定义弹窗（AlertView）
//
//  Created by huju on 16/7/18.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import "ViewController.h"
#import "AlertView.h"
#import "TDBarcode.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self captureBarCode];
}

- (void)captureBarCode
{
    // 1. 实例化拍摄设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3. 设置元数据输出
    // 3.1 实例化拍摄元数据输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.3 设置输出数据代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4. 添加拍摄会话
    // 4.1 实例化拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 4.2 添加会话输入
    [session addInput:input];
    // 4.3 添加会话输出
    [session addOutput:output];
    // 4.3 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.session = session;
    
    // 5. 视频预览图层
    // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.view.bounds;
    // 5.2 将图层插入当前视图
    [self.view.layer insertSublayer:preview atIndex:100];
    
    self.previewLayer = preview;
    
    // 6. 启动会话
    [_session startRunning];
}

- (void)creatBarCode
{
    // 设置中间的View
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    // 显示二维码控件
    UIImageView *imgV = [[UIImageView alloc] init];
    [view addSubview:imgV];
    CGFloat imgvH = 100;
    CGFloat imgVW = imgvH;
    CGFloat imgVY = 10;
    CGFloat imgVX = (KScreenWidth - 150 - imgVW) * 0.5;
    imgV.frame = CGRectMake(imgVX, imgVY, imgVW, imgvH);
    NSDictionary *dic = @{@"name" : @"jake", @"age" : @"14"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    imgV.image = [TDBarcode TwoDBarcodeImageWith:data size:100];
    
    // 弹窗
    AlertView *alert = [AlertView alertWithTitlt:@"支付" messageView:view msgheight:120 leftBtn:@"取消" rightBtn:@"确认" extraData:nil andCompleteBlock:^(AlertView *alertView, NSInteger buttonIndex) {
        NSLog(@"=======%ld", (long)buttonIndex);
    }];
    // 显示弹窗
    [alert showView];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    NSLog(@"%@", metadataObjects);
    // 3. 设置界面显示扫描结果
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        //        _label.text = obj.stringValue;
        NSLog(@"%@", obj.stringValue);
        
        // 设置中间的View
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.text = obj.stringValue;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:19];
        
        [view addSubview:lable];
        CGFloat imgvH = 50;
        CGFloat imgVW = KScreenWidth - 150;
        CGFloat imgVY = 10;
        CGFloat imgVX = (KScreenWidth - 150 - imgVW) * 0.5;
        lable.frame = CGRectMake(imgVX, imgVY, imgVW, imgvH);
        
        // 弹窗
        AlertView *alert = [AlertView alertWithTitlt:@"支付" messageView:view msgheight:70 leftBtn:@"取消" rightBtn:@"确认" extraData:nil andCompleteBlock:^(AlertView *alertView, NSInteger buttonIndex) {
            NSLog(@"=======%ld", (long)buttonIndex);
        }];
    
        // 显示弹窗
        [alert showView];
        
    }
}
@end
