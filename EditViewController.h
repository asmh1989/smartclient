//
//  EditViewController.h
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Finish)(NSString *value);
@interface EditViewController : UITableViewController <UITextFieldDelegate>

- (id) initWithTitleAndName:(NSString *)title Name:(NSString *)name Complete:(Finish) f;
@end
