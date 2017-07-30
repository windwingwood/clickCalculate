//
//  calculateModel+numberSystem.h
//  clickCalculate
//
//  Created by 月砂 on 2017/7/20.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "calculateModel.h"

@interface calculateModel (numberSystem)

/**
 十进制转十六进制数

 @param decimal 十进制字符串
 @return 十六进制字符串
 */
- (NSString *)hexFrom:(NSString *)decimal;
/**
 十六进制转十进制数

 @param hex 十六进制字符串，支持FF或0xFF两种形式
 @return 十进制字符串
 */
- (NSString *)decimalFrom:(NSString *)hex;


@end
