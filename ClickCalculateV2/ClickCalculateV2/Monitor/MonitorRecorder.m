//
//  MonitorRecorder.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/15.
//

#import "MonitorRecorder.h"
#import "NetworkSpeed.h"
#import "HardwareUsage.h"
#import "SMCReader.h"

@interface MonitorRecorder () <NetworkSpeedDelegate>

@property (nonatomic, strong) NetworkSpeed *network;

@property (nonatomic, strong) HardwareUsage *hardware;

@property (nonatomic, strong) SMCReader *smc;

@property (nonatomic, strong) NSArray *config;

@property (nonatomic, strong) NSTimer *recordTimer;

@end

@implementation MonitorRecorder

+ (instancetype)recorder {
    static MonitorRecorder *rd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rd = [MonitorRecorder new];
    });
    return rd;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view = [MonitorView monitorView];
        [self loadConfig];
    }
    return self;
}

- (void)loadConfig {
    NSArray *defaultConfig = @[@(MonitorType_Temperature), @(MonitorType_Upload), @(MonitorType_Download)];
    self.config = defaultConfig;
    for (NSNumber *typeNumber in self.config) {
        MonitorType type = [typeNumber unsignedIntegerValue];
        [self.view addItemWithTitle:[self titleWithType:type]];
    }
    
    self.network = [NetworkSpeed new];
    self.network.delegate = self;
    [self.network start];
    
    self.hardware = [HardwareUsage new];
    self.smc = [SMCReader new];
    
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(normalUpdateRecord) userInfo:nil repeats:YES];
}

- (void)normalUpdateRecord {
    [self.hardware updateRecord];
    [self.smc updateRecord];
    for (NSInteger i=0; i<self.config.count; i++) {
        MonitorType type = [self.config[i] unsignedIntegerValue];
        if (type == MonitorType_CPU) {
//            [self.view updateItem:uploadSpeed atIndex:i];
        }
        else if (type == MonitorType_Temperature) {
            [self.view updateItem:[NSString stringWithFormat:@"%.1f°", self.smc.temperature] atIndex:i];
        }
    }
}

- (void)networkSpeedDidUpdate:(NSString *)uploadSpeed with:(NSString *)downloadSpeed {
    for (NSInteger i=0; i<self.config.count; i++) {
        MonitorType type = [self.config[i] unsignedIntegerValue];
        if (type == MonitorType_Upload) {
            [self.view updateItem:uploadSpeed atIndex:i];
        }
        else if (type == MonitorType_Download) {
            [self.view updateItem:downloadSpeed atIndex:i];
        }
    }
}

- (NSString *)titleWithType:(MonitorType)type {
    switch (type) {
        case MonitorType_Upload:
            return @"上 传";
        case MonitorType_Download:
            return @"下 载";
        case MonitorType_CPU:
            return @"CPU";
        case MonitorType_Memory:
            return @"内 存";
        case MonitorType_Temperature:
            return @"温 度";
        case MonitorType_Fan:
            return @"风 扇";
        default:
            return @"Error";
    }
}

@end
