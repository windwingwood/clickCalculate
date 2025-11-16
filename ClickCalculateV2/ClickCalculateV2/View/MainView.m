//
//  MainView.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/12.
//

#import "MainView.h"
#import "JSTextField.h"
#import "DataTransform.h"

#import "MonitorView.h"

@interface MainView ()

@property (nonatomic, strong) JSTextField *textField;

@property (nonatomic, strong) NSButton *cleanButton;

@property (nonatomic, strong) NSButton *hexButton;

@property (nonatomic, strong) NSButton *decimalButton;

@property (nonatomic, strong) NSButton *RGBButton;

@property (nonatomic, strong) NSButton *settingButton;

@property (nonatomic, strong) NSButton *monitorButton;

@property (nonatomic, strong) NSButton *exitButton;

@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.frame = CGRectMake(0, 0, 300, 100);
    
    self.settingButton = [self addButton:@"设置" origin:CGPointMake(0, 5) target:self action:@selector(clickSetting)];
    self.monitorButton = [self addButton:@"监控" origin:CGPointMake(65, 5) target:self action:@selector(clickMonitor)];
    self.exitButton = [self addButton:@"退出" origin:CGPointMake(CGRectGetWidth(self.view.frame) - 70, 5) target:self action:@selector(clickExit)];
    
    self.hexButton = [self addButton:@"16进制" origin:CGPointMake(0, 30+5) target:self action:@selector(clickHex)];
    self.decimalButton = [self addButton:@"10进制" origin:CGPointMake(65, 30+5) target:self action:@selector(clickDecimal)];
    self.RGBButton = [self addButton:@"RGB转换" origin:CGPointMake(65*2, 30+5) target:self action:@selector(clickRGB)];
    self.RGBButton.frame = CGRectMake(65*2, 30+5, 80, 25);
    
    JSTextField *textField = [[JSTextField alloc] initWithFrame:CGRectMake(10, 100-22-10, 300 - 80, 22)];
    textField.alignment = NSTextAlignmentRight;
    textField.maximumNumberOfLines = 1;
    textField.bezelStyle = NSTextFieldRoundedBezel;
    [self.view addSubview:textField];
    self.textField = textField;
    
    self.cleanButton = [self addButton:@"清空" origin:CGPointMake(CGRectGetWidth(self.view.frame)-70, 100-25-10) target:self action:@selector(clickClean)];
    
    MonitorView *v = [MonitorView monitorView];
    v.frame = CGRectMake(150, 5, v.frame.size.width, v.frame.size.height);
    [self.view addSubview:v];
}

#pragma mark - UI

- (NSButton *)addButton:(NSString *)title origin:(CGPoint)origin target:(nullable id)target action:(nullable SEL)action {
    NSButton *button = [NSButton buttonWithTitle:title target:target action:action];
    button.frame = CGRectMake(origin.x, origin.y, 70, 25);
    [self.view addSubview:button];
//    button.wantsLayer = YES;
//    button.layer.backgroundColor = NSColor.redColor.CGColor;
    return button;
}

#pragma mark - Action

- (void)clickClean {
    [self.textField clean];
}

- (void)clickSetting {
    
}

- (void)clickMonitor {
    
}

- (void)clickExit {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)clickHex {
    [self.textField inputString:[DataTransform hexToDecimal:self.textField.stringValue]];
}

- (void)clickDecimal {
    [self.textField inputString:[DataTransform decimalToHex:self.textField.stringValue]];
}

- (void)clickRGB {
    [self.textField inputString:[DataTransform convertRGB:self.textField.stringValue]];
}

#pragma mark -

@end
