//
//  StringInputTableViewCell.h
//  ShootStudio
//
//  Created by Tom Fewster on 19/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class StringInputTableViewCell;

@interface StringInputTableViewCell : UITableViewCell {
	UITextField *textField;
}

@property (nonatomic, strong) NSString *stringValue;
@property (nonatomic, strong) UITextField *textField;

@end
