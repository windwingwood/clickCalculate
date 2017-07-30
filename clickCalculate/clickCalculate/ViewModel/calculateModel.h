//
//  calculateModel.h
//  clickCalculate
//
//  Created by 月砂 on 2017/7/19.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CM_TypeDecimal = 2,
    CM_TypeHex
} CMType;

@interface calculateModel : NSObject

@property (nonatomic, assign) CMType type;

/**
 算式计算函数
 
 解析算式字符串并输出结果。
 
 目前支持浮点数,+,-,*,/,%,()共计7类型输入。

 @param string 算式字符串
 @return 结果字符串
 */
+ (NSString *)calculateBy:(NSString *)string;

@end
