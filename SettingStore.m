//
//  SettingStore.m
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SettingStore.h"

@implementation SettingStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareStore];
}

+ (SettingStore *)shareStore
{
    static SettingStore *shareStore = nil;
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}

- (NSString *)settingsArchivePath
{
    NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cacheDirectory = [cacheDirectories objectAtIndex:0];
    
    return [cacheDirectory stringByAppendingPathComponent:@"settings.archive"];
}

- (id)init
{
    self = [super init];
    if(self) {
        NSString *path = [self settingsArchivePath];
        settings = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if(!settings) {
            NSLog(@"没有发现固化数据。。。");
            settings = [[SettingForConnect alloc] init];
        }
    }
    return self;
}


- (BOOL)saveSettingsConfig
{
    NSString *path = [self settingsArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:settings toFile:path];
}

-(SettingForConnect *)getSettings
{
    return settings;
}

@end
