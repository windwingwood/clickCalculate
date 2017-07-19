//
//  calculateModel.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/19.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "calculateModel.h"

#pragma mark - 符号栈和数据栈

@interface symbol : NSObject

@property (nonatomic, assign) char data;
@property (nonatomic, strong) symbol *next;

- (symbol *)push:(char)data;

@end

@implementation symbol

- (symbol *)push:(char)data{
    symbol * head = [symbol new];
    head.data = data;
    head.next = self;
    return head;
}

@end

@interface number : NSObject

@property (nonatomic, assign) double data;
@property (nonatomic, strong) number *next;

- (number *)push:(double)data;

@end

@implementation number

- (number *)push:(double)data{
    number * head = [number new];
    head.data = data;
    head.next = self;
    return head;
}

@end

#pragma mark -

@implementation calculateModel

+ (NSString *)calculateBy:(NSString *)nss{
    //先实现最基本的加减乘除功能
    //初始化
    char str[nss.length];
    char * strP = str;
    char ** p = &strP;
    char temp;
    symbol * symStack = [symbol new];
    number * numStack = [number new];
    strcpy(str, [nss UTF8String]);
    //语句分析
    do {
        temp = [calculateModel getSymbol:p];
        if (temp == -1) return @"式子不合法！";
        if (temp == -2) numStack = [numStack push:[calculateModel getNumber:p]];
        else symStack = [symStack push:temp];
        
    } while (temp);
    //递归计算
    NSNumberFormatter * f = [NSNumberFormatter new];
    f.minimumFractionDigits = 0;
    f.maximumFractionDigits = 10;
    return [f stringFromNumber:@(numStack.data)];
}

+ (double)getNumber:(char **)p {
    double temp = 0;
    double decimal = 10;
    while (**p <= 57 && **p >= 48) {
        temp *= 10;
        temp += (**p) - 48;
        (*p)++;
    }
    if (**p == 46) {
        (*p)++;
        while (**p <= 57 && **p >= 48) {
            temp += ((**p) - 48)/decimal;
            decimal *= 10;
            (*p)++;
        }
    }
    NSLog(@"%lf",temp);
    return temp;
}

+ (char)getSymbol:(char **)string {
    char temp = **string;
    switch (temp) {
        case '+':
        case '-':
        case '*':
        case '/':
        case '%':
        case '(':
        case ')':
        case '\0':
            (*string)++;
            return temp;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '.':
            return -2;
        default:
            break;
    }
    return -1;
}

@end
