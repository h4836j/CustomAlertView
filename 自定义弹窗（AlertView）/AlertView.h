//
//  AlertView.h
//  自定义弹窗（AlertView）
//
//  Created by huju on 16/7/18.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

@class AlertView;
typedef void(^AlertViewBlock)(AlertView *alertView, NSInteger buttonIndex);

@interface AlertView : UIView

/** 中间view的高度 */
@property (assign, nonatomic) CGFloat msgHeight;
/** 标题的高度 默认为50 */
@property (assign, nonatomic) CGFloat titleHeigh;
/** 底部控制区域的高度 默认为50 */
@property (assign, nonatomic) CGFloat chooseHeigh;
/** 弹窗宽度 */
@property (assign, nonatomic) CGFloat alertWidth;
/** 弹窗高度 */
@property (assign, nonatomic) CGFloat alertHeight;
/** 是否有弹窗动画 默认为NO */
@property (assign, nonatomic) BOOL animation;

/**
 *  弹框AlertView（默认有一个标题为确定的按钮）
 *
 *  @param title   标题
 *  @param view    中间视图View
 *  @param height  中间视图高度
 *  @param BtnName 按钮标题
 *  @param aData   保存的数据
 *  @param aBlock  回调block
 *
 *  @return AlertView
 */
+ (instancetype)alertWithTitlt:(NSString *)title messageView:(UIView *)view msgheight:(CGFloat)height button:(NSString *)BtnName extraData:(id)aData andCompleteBlock:(AlertViewBlock)aBlock;
/**
 *  弹框AlertView（默认有一个标题为确定的按钮）
 *
 *  @param title        标题
 *  @param view         中间视图View
 *  @param height       中间视图高度
 *  @param leftBtnName  左按钮标题
 *  @param rightBtnName 右按钮标题
 *  @param aData        保存的数据
 *  @param aBlock       回调block
 *
 *  @return AlertView
 */
+ (instancetype)alertWithTitlt:(NSString *)title messageView:(UIView *)view msgheight:(CGFloat)height leftBtn:(NSString *)leftBtnName rightBtn:(NSString *)rightBtnName extraData:(id)aData andCompleteBlock:(AlertViewBlock)aBlock;

/**
 *  显示弹窗
 */
- (void)showView;

@end
