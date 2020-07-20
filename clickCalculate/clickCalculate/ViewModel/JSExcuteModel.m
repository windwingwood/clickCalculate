//
//  JSExcuteModel.m
//  clickCalculate
//
//  Created by 月砂 on 2020/7/20.
//  Copyright © 2020 月砂. All rights reserved.
//

#import "JSExcuteModel.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSExcuteModel ()

@property (nonatomic, strong) JSContext *context;

@end

@implementation JSExcuteModel

+ (instancetype)shareInstance {
    static JSExcuteModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [JSExcuteModel new];
    });
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.context = [JSContext new];
    }
    return self;
}

- (NSString *)calculateBy:(NSString *)string {
    JSValue *value = [self.context evaluateScript:string];
    return [value toString];
}

- (void)clean {
    self.context = [JSContext new];
}

@end
