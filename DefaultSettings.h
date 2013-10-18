//
//  DefaultSettings.h
//  SmartClient
//  一切的默认设置都在此修改
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultSettings : NSObject

@property (nonatomic, copy) NSString *hostIp;
@property (nonatomic) int hostPort;

+ (DefaultSettings *)shareStore;
@end
