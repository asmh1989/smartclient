//
//  DefaultSettings.m
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "DefaultSettings.h"

@implementation DefaultSettings

@synthesize  hostIp, hostPort;


+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareStore];
}

+ (DefaultSettings *)shareStore
{
    static DefaultSettings *shareStore = nil;
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        // vt服务器信息
//        [self setHostIp:@"searching-info.com"];
        [self setHostIp:@"192.168.8.239"];
        [self setHostPort:23];
        
    }
    
    return self;
}


@end
