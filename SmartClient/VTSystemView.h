//
//  VTSystemView.h
//  SmartClient
//
//  Created by sun on 13-10-24.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VTSystemViewDelegate <NSObject>

- (void) handleTouchMessage:(NSString *)msg;

@end

@interface VTSystemView : UIView
@property(assign,nonatomic)id<VTSystemViewDelegate> delegate;
@end
