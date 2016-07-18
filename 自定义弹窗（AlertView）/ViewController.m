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

@interface ViewController ()

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
        NSLog(@"=======%ld", buttonIndex);
    }];
    // 显示弹窗
    [alert showView];
}


@end
