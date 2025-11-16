//
//  AppDelegate.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/12.
//

#import "AppDelegate.h"
#import "MainView.h"
#import "MonitorRecorder.h"

// test
#import "HardwareUsage.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSMenu *mainMenu;

@property (nonatomic, strong) NSStatusItem *statusItem;

@property (nonatomic, strong) NSPopover *popoverView;

@property (nonatomic, strong) MainView *mainView;

@property (nonatomic, strong) id mouseEvent;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSLog(@"启动");
    [self setupStatusBar];
}

- (void)setupStatusBar {
    __weak typeof(self) weakSelf = self;
    [MonitorRecorder recorder].configUpdateBlock = ^(CGFloat width) {
        weakSelf.statusItem.length = width;
    };
    
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:[MonitorRecorder recorder].view.frame.size.width];
    statusItem.button.target = self;
    statusItem.button.action = @selector(clickItem:);
    self.statusItem = statusItem;
    
    [statusItem.button addSubview:[MonitorRecorder recorder].view];
    
    self.mainView = [MainView new];
    
    NSPopover *popoverView = [NSPopover new];
    popoverView.behavior = NSPopoverBehaviorTransient;
    popoverView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    popoverView.contentViewController = self.mainView;
    self.popoverView = popoverView;
}


- (void)clickItem:(NSStatusBarButton *)button {
//    [[NSApplication sharedApplication] setActivationPolicy:NSApplicationActivationPolicyRegular];
    [self.popoverView showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
    if (self.mouseEvent) {
        return;
    }
    self.mouseEvent = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown handler:^(NSEvent *event){
        if (self.popoverView.isShown) [self.popoverView performClose:event];
        if (self.mouseEvent) [NSEvent removeMonitor:self.mouseEvent];
        self.mouseEvent = nil;
    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
