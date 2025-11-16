//
//  NetworkSpeed.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/13.
//

#import "NetworkSpeed.h"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>

#define BUFFER_COUNT 4
#define UPDATE_SECOND 1.0

@interface NetworkSpeedItem : NSObject

@property (nonatomic, assign) long long ibytes;

@property (nonatomic, assign) long long obytes;

@property (nonatomic, assign) long long offsetIn;

@property (nonatomic, assign) long long offsetOut;

@end

@implementation NetworkSpeedItem

@end

@interface NetworkSpeed ()

@property (nonatomic, strong) NSMutableDictionary *storage;

@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation NetworkSpeed {
    long long bufferIn[BUFFER_COUNT];
    long long bufferOut[BUFFER_COUNT];
    int bufferIndex;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _storage = [NSMutableDictionary new];
        bufferIndex = 0;
    }
    return self;
}

- (void)start {
    [self stop];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_SECOND
                                                        target:self
                                                      selector:@selector(update)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)stop {
    if (self.updateTimer) {
        [self.updateTimer invalidate];
    }
    self.updateTimer = nil;
}

- (NSString *)getUploadSpeed {
    long long totalBytes = 0;
    for (int i=0; i<BUFFER_COUNT; i++) {
        totalBytes += bufferIn[i];
    }
    totalBytes = totalBytes/2;
    return [self bytesToString:totalBytes];
}

- (NSString *)getDownloadSpeed {
    long long totalBytes = 0;
    for (int i=0; i<BUFFER_COUNT; i++) {
        totalBytes += bufferOut[i];
    }
    totalBytes = totalBytes/2;
    return [self bytesToString:totalBytes];
}

- (void)callback {
    if (!self.delegate) {
        return;
    }
    
    double bufferBase = BUFFER_COUNT*UPDATE_SECOND;
    long long totalBytesIn = 0;
    long long totalBytesOut = 0;
    for (int i=0; i<BUFFER_COUNT; i++) {
        totalBytesIn += bufferIn[i];
        totalBytesOut += bufferOut[i];
    }
    totalBytesIn = totalBytesIn/bufferBase;
    totalBytesOut = totalBytesOut/bufferBase;
    
    [self.delegate networkSpeedDidUpdate:[self bytesToString:totalBytesOut] with:[self bytesToString:totalBytesIn]];
}

#pragma mark -

- (void)update {
    struct ifaddrs *ifa, *ifa_list = 0;
    if (getifaddrs(&ifa_list) == -1) {
        return;
    }
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        if (strncmp(ifa->ifa_name, "en", 2) != 0)
            continue;
        
        struct if_data *if_data = ifa->ifa_data;
        
        NSString *itemName = [NSString stringWithFormat:@"%s", ifa->ifa_name];
        NetworkSpeedItem *item = [self.storage objectForKey:itemName];
        if (!item) {
            item = [NetworkSpeedItem new];
            [self.storage setObject:item forKey:itemName];
            item.ibytes = if_data->ifi_ibytes;
            item.obytes = if_data->ifi_obytes;
        } else {
            if (item.ibytes < if_data->ifi_ibytes)
                item.offsetIn = if_data->ifi_ibytes - item.ibytes;
            if (item.obytes < if_data->ifi_obytes)
                item.offsetOut = if_data->ifi_obytes - item.obytes;
            
            item.ibytes = if_data->ifi_ibytes;
            item.obytes = if_data->ifi_obytes;
        }
    }
    
    free(ifa_list);
    
    [self plusAllItem];
    [self callback];
}

- (void)plusAllItem {
    long long offsetIn = 0;
    long long offsetOut = 0;
    for (NSString *key in self.storage) {
        NetworkSpeedItem *item = self.storage[key];
        offsetIn += item.offsetIn;
        offsetOut += item.offsetOut;
    }
    bufferIn[bufferIndex] = offsetIn;
    bufferOut[bufferIndex] = offsetOut;
    bufferIndex = (bufferIndex + 1) % BUFFER_COUNT;
}

- (NSString *)bytesToString:(long long)bytes {
    if (bytes < 1024*1024) {
        return [NSString stringWithFormat:@"%.1fK", ((double)bytes)/1024];
    }
    else if (bytes < 1024*1024*1024) {
        return [NSString stringWithFormat:@"%.1fM", ((double)bytes)/1024/1024];
    }
    else {
        return [NSString stringWithFormat:@"%.1fG", ((double)bytes)/1024/1024/1024];
    }
}

@end
