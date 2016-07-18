//
//  AlertView.m
//  自定义弹窗（AlertView）
//
//  Created by huju on 16/7/18.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import "AlertView.h"


@interface AlertView ()
/** 顶部标题视图 */
@property (strong, nonatomic) UIView *titleV;
/** 弹窗标题 */
@property (strong, nonatomic) UILabel *titleL;
/** 中间信息视图 */
@property (strong, nonatomic) UIView *msgV;
/** 底部控制区域视图 */
@property (strong, nonatomic) UIView *chooseV;
/** 顶部标题分割线 */
@property (strong, nonatomic) UIImageView *titleSepV;
/** 底部控制区域分割线 */
@property (strong, nonatomic) UIImageView *chooseSepV;
/** 回掉block */
@property (copy, nonatomic) AlertViewBlock block;
/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttons;
/** 按钮中间的分割线 */
@property (strong, nonatomic) UIImageView *butSepV;
/** 窗口背景视图 */
@property (strong, nonatomic) UIView *backView;


@end

@implementation AlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

/**
 *  初始化控件
 */
- (void)setUp
{
    self.titleHeigh = 50;
    self.chooseHeigh = 50;
    self.msgHeight = 120;
    self.alertHeight = 220;
    self.alertWidth = KScreenWidth - 150;
    self.animation = NO;
    
    // 标题视图
    {
        UIView *titleV = [[UIView alloc] init];
        [self addSubview:titleV];
        self.titleV = titleV;
        titleV.backgroundColor = [UIColor whiteColor];
    }
    // 标题
    {
        UILabel *titleL = [[UILabel alloc] init];
        self.titleL = titleL;
        titleL.font = [UIFont systemFontOfSize:18];
        titleL.textColor = [UIColor grayColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        [self.titleV addSubview:titleL];
    }
    // 标题分割线
    {
        UIImageView *titSep = [[UIImageView alloc] init];
        self.titleSepV = titSep;
        titSep.backgroundColor = [UIColor grayColor];
        [self.titleV addSubview:titSep];
    }
    // 控制区域视图
    {
        UIView *chooseV = [[UIView alloc] init];
        [self addSubview:chooseV];
        self.chooseV = chooseV;
        chooseV.backgroundColor = [UIColor whiteColor];
    }
    // 顶部分割线
    {
        UIImageView *chooseSepV = [[UIImageView alloc] init];
        chooseSepV.backgroundColor = [UIColor grayColor];
        self.chooseSepV = chooseSepV;
        [self.chooseV addSubview:chooseSepV];
    }
    // 按钮之间的竖直分割线
    {
        UIImageView *butSepV = [[UIImageView alloc] init];
        butSepV.backgroundColor = [UIColor grayColor];
        self.butSepV = butSepV;
        [self.chooseV addSubview:butSepV];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

+ (instancetype)alertWithTitlt:(NSString *)title messageView:(UIView *)view msgheight:(CGFloat)height button:(NSString *)BtnName extraData:(id)aData andCompleteBlock:(AlertViewBlock)aBlock
{
    return [self alertWithTitlt:title messageView:view msgheight:height leftBtn:BtnName rightBtn:nil extraData:aData andCompleteBlock:aBlock];
}

+ (instancetype)alertWithTitlt:(NSString *)title messageView:(UIView *)view msgheight:(CGFloat)height leftBtn:(NSString *)leftBtnName rightBtn:(NSString *)rightBtnName extraData:(id)aData andCompleteBlock:(AlertViewBlock)aBlock
{
    AlertView *alert = [[AlertView alloc] init];
    
    // 赋值
    alert.titleL.text = title;
    [alert addSubview:view];
    alert.msgV = view;
    alert.msgHeight = height;
    alert.block = aBlock;
    
    // 设置一个默认标题
    if (!leftBtnName.length) {
        leftBtnName = @"确定";
    }
    // 左侧标题
    UIButton *leftB = [[UIButton alloc] init];
    leftB.tag = 0;
    leftB.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftB setTitle:leftBtnName forState:UIControlStateNormal];
    [leftB addTarget:alert action:@selector(buttonClink:) forControlEvents:UIControlEventTouchUpInside];
    [alert.chooseV addSubview:leftB];
    [alert.buttons addObject:leftB];
    [leftB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    // 右侧标题，需要判断，可能只有一个
    if (rightBtnName.length) {
        UIButton *rightBtn = [[UIButton alloc] init];
        rightBtn.tag = 1;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn setTitle:rightBtnName forState:UIControlStateNormal];
        [rightBtn addTarget:alert action:@selector(buttonClink:) forControlEvents:UIControlEventTouchUpInside];
        [alert.chooseV addSubview:rightBtn];
        [alert.buttons addObject:rightBtn];
        [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
    // 根据默认值设置尺寸
    CGFloat alertW = alert.alertWidth;
    CGFloat alertH = alert.alertHeight;
    CGFloat alertX = (KScreenWidth - alertW) * 0.5;
    CGFloat alertY = KScreenHeight * 1.5;
    alert.frame = CGRectMake(alertX, alertY, alertW, alertH);
    
    return alert;
}

// 按钮点击事件
- (void)buttonClink:(UIButton *)btn
{
    if (self.block) {
        self.block(self, btn.tag);
    }
    [self close];
}



// 显示弹窗
- (void)showView
{
    // 取得keyWindow
    UIView *parent = [UIApplication sharedApplication].keyWindow;
    // 创建一个背景视图
    UIView *back = [[UIView alloc]initWithFrame:parent.bounds];
    back.backgroundColor = [UIColor blackColor];
    back.alpha = 0.0;
    self.backView = back;
    // 将背景视图添加至keyWindow
    [parent addSubview:self.backView];
    // 将自己（alertView）添加到keyWindow
    [parent addSubview:self];
    
    // 改变背景透明度
    [UIView animateWithDuration:0.2 * self.animation + 0.1 delay:0.0f options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.backView.alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.animation) {
        // 动画从底部弹出
        [UIView  animateWithDuration:0.3 animations:^{
            CGFloat alertW = self.frame.size.width;
            CGFloat alertH = self.frame.size.height;
            CGFloat alertX = (KScreenWidth - alertW) * 0.5;
            CGFloat alertY = (KScreenHeight - alertH) * 0.5;
            self.frame = CGRectMake(alertX, alertY, alertW, alertH);
        }];
    } else {
        CGFloat alertW = self.frame.size.width;
        CGFloat alertH = self.frame.size.height;
        CGFloat alertX = (KScreenWidth - alertW) * 0.5;
        CGFloat alertY = (KScreenHeight - alertH) * 0.5;
        self.frame = CGRectMake(alertX, alertY, alertW, alertH);
    }
    
    
    // 给背景添加手势识别，点击可以关闭视图
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.backView addGestureRecognizer:tap];
    
}

// 关闭弹窗
- (void)close
{
    if (self.animation) {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGFloat alertW = self.frame.size.width;
            CGFloat alertH = self.frame.size.height;
            CGFloat alertX = (KScreenWidth - alertW) * 0.5;
            CGFloat alertY = self.frame.origin.y - KScreenHeight;
            self.frame = CGRectMake(alertX, alertY, alertW, alertH);
            self.backView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [self.backView removeFromSuperview];
            [self removeFromSuperview];
        }];
    } else {
        self.backView.alpha = 0;
        [self.backView removeFromSuperview];
        [self removeFromSuperview];
    }
    
    
    
}

// 布局视图尺寸
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfWidth = self.frame.size.width;
    NSInteger butCount = self.buttons.count;
    
    // 设置各个控件的frame
    self.titleV.frame = CGRectMake(0, 0, selfWidth, self.titleHeigh);
    self.titleSepV.frame = CGRectMake(0, self.titleHeigh - 1, selfWidth, 1);
    self.titleL.frame = CGRectMake(0, 0, selfWidth, self.titleHeigh - 1);
    
    self.msgV.frame = CGRectMake(0, self.titleHeigh, selfWidth, self.msgHeight);
    
    self.chooseV.frame = CGRectMake(0, CGRectGetMaxY(self.msgV.frame), selfWidth, self.chooseHeigh);
    self.chooseSepV.frame = CGRectMake(0, 0, selfWidth, 1);
    // 两个标题时显示竖直分割线
    if (butCount > 1) {
        self.butSepV.frame = CGRectMake((selfWidth - 1) * 0.5, 1, 1, self.chooseHeigh - 1);
        
    }
    // 设置按钮frame
    CGFloat butY = 1;
    CGFloat butH = self.chooseHeigh - 1;
    CGFloat butW = (selfWidth - butCount + 1) / butCount;
    for (int i = 0; i < self.buttons.count; i++) {
        CGFloat butX = (butW + 1) * i;
        UIButton *btn = self.buttons[i];
        btn.frame = CGRectMake(butX, butY, butW, butH);
    }
    
    
    
}

@end
