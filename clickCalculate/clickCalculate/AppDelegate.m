//
//  AppDelegate.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/11.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "AppDelegate.h"
#import "calculateView.h"
#import "NetworkStatsModel.h"
#import <objc/runtime.h>

@interface AppDelegate () <NetworkStats>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) calculateView *calView;
@property (weak) IBOutlet NSMenu *mainMenu;


@end

@implementation AppDelegate {
    id eventMonitor;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self setStatusBar];
//    [self setRuntime];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - 

//- (void)setRuntime{
//    Method windowKeyDown = class_getInstanceMethod([NSTextField class], @selector(keyDown:));
//    Method textKeyDown = class_getInstanceMethod([WTextField class], @selector(keyDown:));
//    method_exchangeImplementations(windowKeyDown, textKeyDown);
////    IMP myIMP = (IMP)method_getImplementation(textKeyDown);
////    class_replaceMethod([NSResponder class], @selector(keyDown:), myIMP, "v@:@");
//    
//}

/**
 设置状态栏插件的所有功能。
 
 statusItem设置为可变长度，将会随着title的长度进行变化
 */
- (void)setStatusBar {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.target = self;
    _statusItem.button.action = @selector(clickItem:);
    _statusItem.title = @"0KB/s";
    
    [self setPopover];
    [self setNetworkStats];
}

/**
 设置popover页面，即点击item显示的页面。
 */
- (void)setPopover {
    _calView = [calculateView new];
    _popover = [NSPopover new];
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _popover.contentViewController = _calView;
}

/**
 statusItem的点击事件
 
 调用show让popover显示，之后添加一个全局鼠标监控。
 
 block的内容是鼠标在其他地方按下时，关闭popover。
 这里有一个要点，通过点击按钮来关闭popover时不会触发block。
 防止monitor添加过多而没有移除，需要进行存在判断。
 
 另外，点击1次会block会触发4次。
 
 @param button 点击的状态栏按钮
 */
- (void)clickItem:(NSStatusBarButton *)button {
    [_popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
    if (!eventMonitor) {
        eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown handler:^(NSEvent *event){
            if (_popover.isShown) [_popover performClose:event];
            if (eventMonitor) {
                [NSEvent removeMonitor:eventMonitor];
                eventMonitor = nil;
            }
        }];
    }
}

/**
 设置流量监控。
 
 代理会将网速作为NSString传回来。
 
 - (void)start方法启动流量监控。
 */
- (void)setNetworkStats {
    NetworkStatsModel * instance = [NetworkStatsModel sharedInstance];
    instance.delegate = self;
    [instance start];
}

#pragma mark - NetworkStats delegate

- (void)flowDidRefrush:(NSString *)download with:(NSString *)upload {
    _statusItem.title = download;
}

@end
