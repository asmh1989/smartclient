//
//  SettingForConnect.m
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SettingForConnect.h"
#import "DefaultSettings.h"



@implementation SettingForConnect

@synthesize hostIp, hostPort,deviceID, enc;


- (id)init
{
    [self setHostIp:[[DefaultSettings shareStore] hostIp]];
    [self setHostPort:[[DefaultSettings shareStore] hostPort]];
    [self setDeviceID:[self uuid]];
    [self setEnc:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]; // use GB2312
    
    return self;
}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid );
    NSString * result = (__bridge NSString *)uuidString;
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setHostIp:[aDecoder decodeObjectForKey:@"hostIp"]];
        [self setHostPort:[aDecoder decodeIntForKey:@"hostPort"]];
        [self setDeviceID:[aDecoder decodeObjectForKey:@"deviceID"]];
        [self setEnc:[aDecoder decodeIntForKey:@"enc"]];
    }
    
    NSLog(@"initWithCoder, hostIp = %@", hostIp);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:hostIp forKey:@"hostIp"];
    [aCoder encodeInt:hostPort forKey:@"hostPort"];
    [aCoder encodeObject:deviceID forKey:@"deviceID"];
    [aCoder encodeInt:enc forKey:@"enc"];
    
    NSLog(@"encodeWithCoder, hostIp = %@", hostIp);
}



@end
