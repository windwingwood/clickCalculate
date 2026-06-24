//
//  Interface.m
//  ClickCalculateV2
//
//  Created by YP on 2026/6/24.
//

#import "Interface.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

@interface Interface ()

@property (nonatomic, strong) NSThread *serverThread;

@property (nonatomic, assign) int serverSocket;

@end

@implementation Interface

+ (instancetype)sharedInstace {
    static Interface *face = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        face = [self new];
    });
    return face;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _serverSocket = -1;
    }
    return self;
}

- (void)start:(int)port {
    NSLog(@"Start Interface");
    if (self.serverThread.isExecuting) return;
    
    self.serverThread = [[NSThread alloc] initWithTarget:self selector:@selector(runLoop:) object:@(port)];
    [self.serverThread start];
}

- (void)stop {
    NSLog(@"Stop Interface");
    if (self.serverSocket >= 0) {
        close(self.serverSocket);
        self.serverSocket = -1;
    }
    [self.serverThread cancel];
    self.serverThread = nil;
}

- (void)runLoop:(NSNumber *)portArg {
    uint16_t port = portArg.unsignedShortValue;
    
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) { NSLog(@"socket 创建失败"); return; }
    
    int reuse = 1;
    setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
    
    struct sockaddr_in addr = {
        .sin_len = sizeof(struct sockaddr_in),
        .sin_family = AF_INET,
        .sin_port = htons(port),
        .sin_addr.s_addr = INADDR_ANY
    };
    
    if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        NSLog(@"绑定端口 %d 失败", port); close(sock); return;
    }
    
    listen(sock, 5);
    self.serverSocket = sock;
    NSLog(@"Listen: http://127.0.0.1:%d", port);
    
    while (!self.serverThread.isCancelled) {
        fd_set readSet;
        FD_ZERO(&readSet);
        FD_SET(sock, &readSet);
        struct timeval timeout = { .tv_sec = 1, .tv_usec = 0 };
        
        if (select(sock + 1, &readSet, NULL, NULL, &timeout) <= 0) continue;
        
        struct sockaddr_in clientAddr;
        socklen_t len = sizeof(clientAddr);
        int client = accept(sock, (struct sockaddr *)&clientAddr, &len);
        if (client < 0) continue;
        
        [self handleClient:client];
    }
    
    close(sock);
    self.serverSocket = -1;
}

- (void)handleClient:(int)client {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        char buffer[4096] = {0};
        recv(client, buffer, sizeof(buffer) - 1, 0);
        
        NSString *request = [NSString stringWithUTF8String:buffer];
        NSString *path = [self parsePathFromRequest:request];
        
        NSString *body = nil;
        if (self.provider) {
            body = self.provider(path);
        }
        if (!body) {
            body = [NSString stringWithFormat:@"无效指令\n%@\n", [NSDate date]];
        }
        
        NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSString *response = [NSString stringWithFormat:
                              @"HTTP/1.1 200 OK\r\n"
                              @"Content-Type: text/plain; charset=utf-8\r\n"
                              @"Content-Length: %lu\r\n"
                              @"Connection: close\r\n"
                              @"\r\n"
                              @"%@",
                              (unsigned long)bodyData.length, body];
        
        NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
        send(client, responseData.bytes, responseData.length, 0);
        close(client);
    });
}

- (NSString *)parsePathFromRequest:(NSString *)request {
    NSArray *lines = [request componentsSeparatedByString:@"\r\n"];
    if (lines.count == 0) return nil;
    
    NSArray *parts = [lines[0] componentsSeparatedByString:@" "];
    if (parts.count < 2) return nil;
    
    NSString *path = parts[1];
    return path;
}

- (void)dealloc {
    [self stop];
}

@end
