//
//  CameraImage.h
//  SmartClient
//
//  Created by sun on 13-11-8.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraImage : NSObject

- (void) clearCameraImage;
- (int) getCmaeraImageSize;
- (void) addCameraImage:(NSNumber *)index Value:(NSString *)value;
- (NSString *) getCameraImageData:(NSNumber *)index;
- (void) sendCameraImage:(NSNumber *)index;

@property (copy)  void (^sendImageData)(NSString *data);
@end
