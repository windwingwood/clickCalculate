//
//  calculateModel.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/19.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "calculateModel.h"

enum {
    CM_end      =  0,
    CM_invalid  = -1,
    CM_number   = -2,
    CM_push     = -3,
    CM_pop      = -4,
    CM_check    = -5
};

#pragma mark - 数据栈

@interface data : NSObject

@property (nonatomic, assign) char   sym;
@property (nonatomic, assign) double num;
@property (nonatomic, strong) data *next;

- (data *)pushSym:(char)ch;             //栈式压入，返回头
- (data *)EnSym:(char)ch;               //队式压入，返回尾
- (data *)EnNum:(double)num;            //队式压入，返回尾
- (data *)EnFrom:(data *)stack;         //栈压入队，返回尾

@end

@implementation data

- (data *)pushSym:(char)ch {
    data * head = [data new];
    head.sym = ch;
    head.next = self;
    return head;
}

- (data *)EnSym:(char)ch {
    data * head = [data new];
    head.sym = ch;
    self.next = head;
    return head;
}

- (data *)EnNum:(double)num {
    data * head = [data new];
    head.num = num;
    self.next = head;
    return head;
}

- (data *)EnFrom:(data *)stack {
    if (stack.next == nil) return self;
    self.next = stack;
    data * temp = stack;
    while (temp.next.next != nil && temp.sym != '(') {
        temp = temp.next;
    }
    return temp;
}

@end

#pragma mark -

@implementation calculateModel

- (instancetype)init{
    if (self = [super init]) {
        _type = CM_TypeDecimal;
    }
    return self;
}

+ (NSString *)calculateBy:(NSString *)nss{
    if ([nss isEqualToString:@""]) return nss;
    //初始化
    char str[nss.length];
    char *  strP = str;
    char ** p    = &strP;
    char temp;
    data * dataQueue = [data new];
    data * tempStack = [data new];
    data * dataStack = dataQueue;
    strcpy(str, [nss UTF8String]);
    //语句分析
    temp = [self filter:p];
    do {
        if (temp == CM_invalid) return @"式子不合法！";
        if (temp == CM_number) dataStack = [dataStack EnNum:[self getNumber:p]];
        if (temp == CM_push) tempStack = [tempStack pushSym:[self getSymbol:p]];
        if (temp == CM_pop) {
            dataStack = [dataStack EnFrom:tempStack];
            tempStack = dataStack.next;
            dataStack.next = nil;
        }
        if (temp == CM_check) {
            //比较栈中的符号优先级
            //高的话压入，低或者相同的话交换
            if (tempStack.sym == CM_end) {
                tempStack = [tempStack pushSym:[self getSymbol:p]];
            } else {
                temp = [self getSymbol:p];
                if ([self symbolLevel:temp] >= [self symbolLevel:tempStack.sym]) {
                    //交换
                    dataStack = [dataStack EnSym:tempStack.sym];
                    tempStack.sym = temp;
                } else tempStack = [tempStack pushSym:temp];
            }
        }
        temp = [self filter:p];
    } while (temp);
    [dataStack EnFrom:tempStack];
    //解析计算
    return [self calculate:dataQueue.next];
}

+ (char)filter:(char **)string {
    char temp = **string;
    switch (temp) {
        case '(':
            return CM_push;
        case ')':
            (*string)++;
            return CM_pop;
        case '*':
        case '/':
        case '%':
        case '+':
        case '-':
            return CM_check;
        case '\0':
            return CM_end;
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
            return CM_number;
        default:
            break;
    }
    return CM_invalid;
}

+ (int)symbolLevel:(char)ch {
    switch (ch) {
        case '*':
        case '/':
        case '%':
            return 3;
        case '+':
        case '-':
            return 4;
            
        default:
            break;
    }
    return 16;
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
//    NSLog(@"%lf",temp);
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
            (*string)++;
            return temp;
        default:
            break;
    }
    return CM_invalid;
}

+ (NSString *)calculate:(data *)dataQueue{
    //初始化
    int length = 0;
    data * temp = dataQueue;
    while (temp.next != nil) {
        length++;
        temp = temp.next;
    }
    double numStack[length/2];
    int level = 0;
    //开始计算
    while (dataQueue != nil) {
        if (dataQueue.sym != 0) {
            //符号运算
            switch (dataQueue.sym) {
                case '+':
                    level--;
                    numStack[level-1] += numStack[level];
                    break;
                case '-':
                    level--;
                    numStack[level-1] -= numStack[level];
                    break;
                case '*':
                    level--;
                    numStack[level-1] *= numStack[level];
                    break;
                case '/':
                    level--;
                    numStack[level-1] /= numStack[level];
                    break;
                case '%':
                    level--;
                    numStack[level-1] -= (int)(numStack[level-1] / numStack[level]) * numStack[level];
                    break;
                default:
                    break;
            }
        } else {
            numStack[level] = dataQueue.num;
            level++;
        }
        dataQueue = dataQueue.next;
    }
    //输出
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    formatter.minimumIntegerDigits = 1;
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 10;
    return [formatter stringFromNumber:@(numStack[0])];
}

@end

