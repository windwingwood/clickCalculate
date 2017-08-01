//
//  calculateView.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/18.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "calculateView.h"

@interface calculateView ()
@property (weak) IBOutlet NSButton *cleanButton;
@property (weak) IBOutlet NSButton *hexButton;
@property (weak) IBOutlet NSButton *decimalButton;
@property (weak) IBOutlet NSButton *RGBButton;
@property (weak) IBOutlet NSButton *darkModeButton;
@property (weak) IBOutlet NSButton *preferencesButton;
@property (weak) IBOutlet NSButton *exitButton;

@end

@implementation calculateView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLocalizations];
    _model = [calculateModel new];
    [_inputText setKeyUp:^(unsigned short code) {
        if (code == 36) {
            [_inputText setStringValue:[_model calculateBy:_inputText.stringValue]];
        }
    }];
}

- (void)setLocalizations {
    _cleanButton.title = NSLocalizedString(@"clean", nil);
    _hexButton.title = NSLocalizedString(@"hex", nil);
    _decimalButton.title = NSLocalizedString(@"decimal", nil);
    _RGBButton.title = NSLocalizedString(@"RGBchange", nil);
    _darkModeButton.title = NSLocalizedString(@"darkmode", nil);
    _preferencesButton.title = NSLocalizedString(@"preferences", nil);
    _exitButton.title = NSLocalizedString(@"exit", nil);
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

- (IBAction)clickRGB:(id)sender {
    [_inputText setStringValue:[_model changeRGBFrom:_inputText.stringValue]];
}

/**
 启动/关闭 暗黑模式
 
 通过appleScript实现对系统设置的操作。
 appleScript真好用。

 @param sender 没什么意义的sender
 */
- (IBAction)clickDark:(id)sender {
    static NSString *source = @"tell application \"System Events\" \ntell appearance preferences to set dark mode to not dark mode \nend tell";
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:source];
    [appleScript executeAndReturnError:nil];
}

- (IBAction)clickExit:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

@end
