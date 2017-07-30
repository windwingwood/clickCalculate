//
//  calculateView.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/18.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "calculateView.h"

@interface calculateView ()

@end

@implementation calculateView

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [calculateModel new];
    [_inputText setKeyUp:^(unsigned short code) {
        if (code == 36) {
            [_inputText setStringValue:[calculateModel calculateBy:_inputText.stringValue]];
        }
    }];
}

#pragma mark - 

- (IBAction)clickClean:(id)sender {
    [_inputText setStringValue:@""];
}

- (IBAction)clickHex:(id)sender {
    [_inputText setStringValue:[_model hexFrom:_inputText.stringValue]];
}

- (IBAction)clickDecimal:(id)sender {
    [_inputText setStringValue:[_model decimalFrom:_inputText.stringValue]];
}

/**
 启动/关闭 暗黑模式
 
 通过appleScript实现对系统设置的操作。
 appleScript真好用。

 @param sender 没什么意义的sender
 */
- (IBAction)clickDark:(id)sender {
    static NSString *const source = @"tell application \"System Events\" \ntell appearance preferences to set dark mode to not dark mode \nend tell";
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:source];
    [appleScript executeAndReturnError:nil];
}

- (IBAction)clickExit:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

@end
