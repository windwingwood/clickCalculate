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
    // Do view setup here.
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
- (IBAction)clickExit:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

@end
