//
//  JSTextField.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/13.
//

#import "JSTextField.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSTextField ()

@property (nonatomic, strong) JSContext *context;

@property (nonatomic, strong) NSMutableArray *textHistory;

@property (nonatomic, assign) NSInteger backIndex;

@end

@implementation JSTextField

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self clean];
    }
    return self;
}

- (void)inputString:(NSString *)stringValue {
    self.stringValue = stringValue;
    [self.textHistory addObject:stringValue];
    self.backIndex = -1;
}

- (void)calculate {
    [self.textHistory addObject:self.stringValue];
    if (self.textHistory.count > 50) {
        [self.textHistory removeObjectsInRange:NSMakeRange(0, 20)];
    }
    self.backIndex = -1;
    
    JSValue *result = [self.context evaluateScript:self.stringValue];
    self.stringValue = [result toString];
}

- (void)clean {
    self.stringValue = @"";
    self.context = [JSContext new];
    self.textHistory = [NSMutableArray new];
    self.backIndex = -1;
}

- (void)keyUp:(NSEvent *)event {
//    NSLog(@"%u", event.keyCode);
    if (event.keyCode == 36) { // enter
        [self calculate];
    }
    else if (event.keyCode == 126) { // arrow up
        if (self.backIndex < 0) {
            self.backIndex = self.textHistory.count;
        }
        if (self.backIndex > 0) {
            self.backIndex--;
            self.stringValue = self.textHistory[self.backIndex];
        }
    }
    else if (event.keyCode == 125 && self.backIndex >= 0) { // arrow down
        if (self.backIndex+1 < self.textHistory.count) {
            self.backIndex++;
            self.stringValue = self.textHistory[self.backIndex];
        } else {
            self.backIndex = self.textHistory.count;
            self.stringValue = @"";
        }
    }
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    if (([event modifierFlags] & NSEventModifierFlagDeviceIndependentFlagsMask) == NSEventModifierFlagCommand) {
        if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
            return [NSApp sendAction:@selector(selectAll:) to:self.window.firstResponder from:self];
        }
        else if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
            return [NSApp sendAction:@selector(cut:) to:self.window.firstResponder from:self];
        }
        else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
            return [NSApp sendAction:@selector(copy:) to:self.window.firstResponder from:self];
        }
        else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
            return [NSApp sendAction:@selector(paste:) to:self.window.firstResponder from:self];
        }
    }
    return [super performKeyEquivalent:event];
}

@end
