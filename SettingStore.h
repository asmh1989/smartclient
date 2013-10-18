//
//  SettingStore.h
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingForConnect.h"

@interface SettingStore : NSObject
{
    SettingForConnect *settings;
}

+ (SettingStore *)shareStore;

- (BOOL) saveSettingsConfig;
- (NSString *)settingsArchivePath;
- (SettingForConnect *)getSettings;
@end
