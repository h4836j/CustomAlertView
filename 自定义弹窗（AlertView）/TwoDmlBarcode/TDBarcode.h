//
//  TDBarcode.h
//  城市2.0
//
//  Created by huju on 16/7/18.
//  Copyright © 2016年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface TDBarcode : NSObject
/**
 *  生成二维码
 *
 *  @param data           需要包含在二维码中信息
 *  @param widthAndHeight 二维码图片的宽、高
 *
 *  @return 二维码图片
 */
+ (UIImage *)TwoDBarcodeImageWith:(NSData *)data size:(CGFloat)widthAndHeight;
@end
