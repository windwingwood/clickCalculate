//
//  MonitorView.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/15.
//

#define MonitorViewItemWidth 40
#define MonitorViewHeight 22

#import "MonitorView.h"

@interface MonitorViewItem : NSView

@property (nonatomic, strong) NSTextField *topLabel;

@property (nonatomic, strong) NSTextField *bottomLabel;

@end

@implementation MonitorViewItem

+ (instancetype)itemWithTitle:(NSString *)title origin:(CGPoint)origin {
    MonitorViewItem *item = [[MonitorViewItem alloc] initWithFrame:CGRectMake(origin.x, origin.y, MonitorViewItemWidth, MonitorViewHeight)];
    item.topLabel.stringValue = title;
    return item;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat offsetX = (MonitorViewItemWidth - 60)/2;
    
    self.topLabel = [self makeLabel:CGRectMake(offsetX, MonitorViewHeight-8, 60, 8)];
    self.topLabel.font = [NSFont systemFontOfSize:6];
    [self addSubview:self.topLabel];
    
    self.bottomLabel = [self makeLabel:CGRectMake(offsetX, 0, 60, MonitorViewHeight-8)];
    self.bottomLabel.stringValue = @"----";
    self.bottomLabel.font = [NSFont systemFontOfSize:12];
    [self addSubview:self.bottomLabel];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
//    [NSColor.redColor set];
//    NSRectFill(self.bounds);
    
    [NSColor.blackColor set];
    NSBezierPath.defaultLineWidth = 0.5;
    [NSBezierPath strokeLineFromPoint:CGPointMake(8, self.bounds.size.height-8)
                              toPoint:CGPointMake(self.bounds.size.width-8, self.bounds.size.height-8)];
}

- (NSTextField *)makeLabel:(NSRect)frame {
    NSTextField *textField = [[NSTextField alloc] initWithFrame:frame];
    textField.alignment = NSTextAlignmentCenter;
    textField.editable = NO;
    textField.selectable = NO;
    textField.bezeled = NO;
    textField.drawsBackground = NO;
    return textField;
}

@end

@interface MonitorView ()

@end

@implementation MonitorView

+ (instancetype)monitorView {
    MonitorView *mv = [[MonitorView alloc] initWithFrame:CGRectMake(0, 0, MonitorViewItemWidth, MonitorViewHeight)];
    return mv;
}

- (void)addItemWithTitle:(NSString *)title {
    MonitorViewItem *item = [MonitorViewItem itemWithTitle:title origin:CGPointMake(self.subviews.count*MonitorViewItemWidth, 0)];
    [self addSubview:item];
    self.frame = CGRectMake(0, 0, self.subviews.count*MonitorViewItemWidth, MonitorViewHeight);
}

- (void)updateItem:(NSString *)value atIndex:(NSInteger)index {
    MonitorViewItem *item = [self.subviews objectAtIndex:index];
    item.bottomLabel.stringValue = value;
}

- (void)removeAllItem {
    for (NSView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
