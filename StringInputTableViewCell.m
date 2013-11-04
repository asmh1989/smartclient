//
//  StringInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 19/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StringInputTableViewCell.h"

@interface StringInputTableViewCell ()
{
    
}

@end

@implementation StringInputTableViewCell


@synthesize stringValue;
@synthesize textField;


- (void)initalizeInputView {
	// Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.textField = [[UITextField alloc] initWithFrame:CGRectInset(self.contentView.frame, 10, 10)];
//	self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
	self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
//	self.textField.textAlignment = UITextAlignmentLeft;
	self.textField.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
	self.textField.font = [UIFont systemFontOfSize:17.0f];
	self.textField.clearButtonMode = UITextFieldViewModeNever;
	self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	[self addSubview:self.textField];
	[self.textField becomeFirstResponder];
	self.accessoryType = UITableViewCellAccessoryNone;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self initalizeInputView];
    }
    return self;
}

- (void)setStringValue:(NSString *)value {
	self.textField.text = value;
}

- (NSString *)stringValue {
	return self.textField.text;
}

@end
