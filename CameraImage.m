//
//  CameraImage.m
//  SmartClient
//
//  Created by sun on 13-11-8.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "CameraImage.h"

@interface CameraImage()

@property (nonatomic) NSMutableDictionary *imageMap;

@end

@implementation CameraImage
@synthesize imageMap, sendImageData;

- (id)init
{
    self = [super init];
    if (self) {
        imageMap  = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)clearCameraImage
{
    [imageMap removeAllObjects];
}

- (NSString *)getCameraImageData:(NSNumber *)index
{
    return [imageMap objectForKey:index];
}

- (void)addCameraImage:(NSNumber *)index Value:(NSString *)value
{
    [imageMap setObject:value forKey:index];
}

- (int)getCmaeraImageSize
{
    return (int)[imageMap count];
}
- (void)sendCameraImage:(NSNumber *)index
{
    if ([imageMap count] < 1) {
        sendImageData([NSString stringWithFormat:@"%@%@", CUSACTIVE_CAM_SEND,@" Result=\"-1\" Message=\"当前照片序列不存在\" />"]);
    } else{
        if ([imageMap objectForKey:index]){
            sendImageData([NSString stringWithFormat:@"%@%@%@%@%@%@", CUSACTIVE_CAM_SEND,
                                       @" Index=\"",index ,@"\" Image=\"", [imageMap objectForKey:index], @"\" />"]);
        }else {
            sendImageData([NSString stringWithFormat:@"%@%@%@%@", CUSACTIVE_CAM_SEND, @" Result=\"-1\" Message=\"当前照片序列不存在", index, @"\" />"]);
        }
    }
}
@end
