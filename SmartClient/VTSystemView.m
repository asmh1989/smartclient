//
//  VTSystemView.m
//  SmartClient
//
//  Created by sun on 13-10-24.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "VTSystemView.h"
#import "StringShowList.h"
#import "SettingForRuntime.h"
#import "SettingStore.h"
#import "ShowListEventArgs.h"

@interface VTSystemView()
{
    StringShowList *stringShowList;
    SettingForConnect *settingStore;
    SettingForRuntime *settings;
}

@end


@implementation VTSystemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


// / <summary>
// / 指派颜色
// / </summary>
// / <param name="CurAttribs">前面字符属性</param>
// / <param name="CurFGColor">ref 前景色</param>
// / <param name="CurBGColor">ref 后景色</param>
- (void) AssignColors:(CharAttribs*) CurAttribs BGColor:(UIColor **)color1 FGColor:(UIColor **)color2
{
	
    UIColor *CurFGColor = settingStore.fgColor;
    UIColor *CurBGColor = settingStore.bgColor;
    
    if (CurAttribs.IsBlinking == YES) {
        CurFGColor = settingStore.blinkColor;
    }
    
    // bold takes precedence over the blink color
    if (CurAttribs.IsBold == YES) {
        CurFGColor = settingStore.boldColor;
    }
    
    if (CurAttribs.UseAltColor == YES) {
        CurFGColor = CurAttribs.AltColor;
    }
    
    // alternate color takes precedence over the bold color
    if (CurAttribs.UseAltBGColor == YES) {
        CurBGColor = CurAttribs.AltBGColor;
    }
    
    if (CurAttribs.IsInverse == YES) {
        UIColor *TmpColor = CurBGColor;
		
        CurBGColor = CurFGColor;
        CurFGColor = TmpColor;
    }
    
    // If light background is on and we're not using alt colors
    // reverse the colors
    if ((settings.mode.flags & MODE_LightBackground) > 0
        && CurAttribs.UseAltColor == NO
        && CurAttribs.UseAltBGColor == NO) {
		
        UIColor *TmpColor = CurBGColor;
		
        CurBGColor = CurFGColor;
        CurFGColor = TmpColor;
    }
    *color1 = CurBGColor;
    *color2 = CurFGColor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (!stringShowList) {
        stringShowList = [ StringShowList shareStore];
        settingStore = [[SettingStore shareStore] getSettings];
        settings = [SettingForRuntime shareStore];
    }

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIFont *myFont = [UIFont boldSystemFontOfSize:16.0];
    int leftMargin = [settingStore leftMargin];
    int topMargin = [settingStore topMargin];
    int columnSpan = [settingStore columnSpan];
    int rowSpan = [settingStore rowSpam];
    
    
    // Get the width of a string ...
    CGSize size = [settings getCharSizeEN:myFont];
    
    for (id key in [[stringShowList stringShowDics] allKeys]) {
        NSArray *showList = [[stringShowList stringShowDics] objectForKey:key];
        
        int i = 0; //行上的第几个
        CGFloat width = 0; //当前的已占据的宽度
        for (ShowListEventArgs *line in showList) {
            UIColor *bgColor = settingStore.bgColor;
            UIColor *fgColor = settingStore.fgColor;
            
            [self AssignColors:line.curCharAttribute BGColor:&bgColor FGColor:&fgColor];
            
            if(bgColor)
                [bgColor setStroke];
            CGFloat X = leftMargin + (size.width+columnSpan) * line.curPoint.x;
            CGFloat Y = topMargin + (size.height+rowSpan) * line.curPoint.y;
//            CGSize s = [line.curString sizeWithFont:myFont];
            CGSize s = CGSizeMake(size.width * [line.curString length], size.height);
            CGRect textRect = CGRectMake(X, Y, s.width, s.height);
            CGContextFillRect(context, CGRectMake(X, Y, s.width, s.height));
            CGContextStrokePath(context);
        
//            if (fgColor) {
//                [fgColor setFill];
//            }
//
//            
//            [line.curString drawInRect:textRect withFont:myFont];
        }
        
    }
    
}


@end
