//
//  SettingForConnect.h
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingForConnect : NSObject <NSCoding>

@property (nonatomic, strong) NSString *hostIp;
@property (nonatomic) int hostPort;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic) NSStringEncoding enc;


@end
