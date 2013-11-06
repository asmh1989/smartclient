//
//  EditViewController.h
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

enum CellType{
    EditCell,
    RadioCell,
    RadioSoundCell
};

typedef void(^Finish)(NSString *value);

@interface EditViewController : UITableViewController <UITextFieldDelegate>

@property(nonatomic) enum CellType type;

- (id) initWithTitleAndName:(NSString *)title Name:(NSString *)name Complete:(Finish) f;
- (id) initWithTitleAndName:(NSString *)title Name:(NSString *)name Complete:(Finish) f EnumType:(enum CellType) type;
- (id) initWithTitleAndName:(NSString *)title Name:(NSString *)name Complete:(Finish) f EnumType:(enum CellType) type DataArray:(NSArray *)data;
- (id) initWithTitleAndName:(NSString *)title Complete:(Finish) f EnumType:(enum CellType) type DataArray:(NSArray *)data FirstSelected:(int)select;
@end
