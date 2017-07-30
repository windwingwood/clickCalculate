//
//  NetworkStatsModel.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/26.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "NetworkStatsModel.h"
#import <net/if.h>
#import <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

static const float refrushTime = 2.0;

typedef struct{
    uint32 iFlow;
    uint32 oFlow;
}flow;

void setflow(flow * a, flow old) {
    a->iFlow = old.iFlow;
    a->oFlow = old.oFlow;
}

@implementation NetworkStatsModel {
    flow flowLast;
    flow flowOffset;
}

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        flowLast.iFlow = 0;
        flowLast.oFlow = 0;
        flowOffset.iFlow = 0;
        flowOffset.oFlow = 0;
    }
    return self;
}

- (void)start {
    setflow(&flowLast, [self refrushNetworkflow]);
    NSTimer * t = [NSTimer timerWithTimeInterval:refrushTime target:self selector:@selector(loopRefrushNetworkStats) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
}

- (void)loopRefrushNetworkStats {
    flow temp = [self refrushNetworkflow];
    [_delegate performSelector:@selector(flowDidRefrush:with:) withObject:[self bytesConvert:temp.iFlow - flowLast.iFlow] withObject:[self bytesConvert:temp.oFlow - flowLast.oFlow]];
    setflow(&flowLast, temp);
}

/**
 单位转换函数

 @param bytes 字节为单位的统计数据
 @return 能显示的最高位单位表示网速的字符串
 */
- (NSString *)bytesConvert:(uint32_t)bytes {
    bytes /= refrushTime;
    if (bytes < 1024)
        return @"0KB/s";
    else if (bytes < 1024*1024)
        return [NSString stringWithFormat:@"%.1fKB/s", (double)bytes/1024];
    else if (bytes < 1024*1024*1024)
        return [NSString stringWithFormat:@"%.1fMB/s", (double)bytes/1024/1024];
    else return [NSString stringWithFormat:@"%.1fGB/s", (double)bytes/1024/1024/1024];
}

- (flow)refrushNetworkflow {
    flow temp = {0,0};
    struct ifaddrs *ifa, *ifa_list = 0;
    
    //获取网络配置链表
    if (getifaddrs(&ifa_list) == -1) {
        temp.iFlow = -1;
        return temp;
    }
    
    //遍历IP列表
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        //判断是不是本地回路，相同返回0，name大于lo则返回大于0的值
        /*
         * en0      wifi iphoneUSB CAD
         * bridge0
         * awdl0    airdrop
         * utun0    虚拟网卡
         */
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            temp.iFlow += if_data->ifi_ibytes;
            temp.oFlow += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    
    return temp;
}


@end
