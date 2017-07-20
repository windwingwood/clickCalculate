//
//  calculateModel+numberSystem.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/20.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "calculateModel+numberSystem.h"

@implementation calculateModel (numberSystem)

- (NSString *)hexFrom:(NSString *)nss {
    char *p = NULL;
    unsigned long num = strtoul([nss UTF8String], &p, 10);
    if (*p != 0) return @"格式错误";
    self.type = CM_TypeHex;
    return [NSString stringWithFormat:@"0x%lX",num];
}

- (NSString *)decimalFrom:(NSString *)hex {
    char *p = NULL;
    unsigned long num = strtoul([hex UTF8String], &p, 16);
    if (*p != 0) return @"格式错误";
    self.type = CM_TypeDecimal;
    return [NSString stringWithFormat:@"%lu",num];
}

@end
