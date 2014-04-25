//
//  ListFormArgs.h
//  SmartClient
//
//  Created by sun on 14-4-22.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListFormArgs : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *sectionTitle;
@property (nonatomic, strong) NSDictionary *listContents;
@end
