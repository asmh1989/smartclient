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
#import "Functions.h"

#define MABS(a,b) ((a) - (b)) > 0 ? ((a)-(b)) : ((b) - (a))
#define MYABS(a,b,N) (((a) - (b)) > 0? ((a)-(b)) : ((b) - (a))) < (N)

#define CLICK_LEN 8

@interface VTSystemView()
{
    StringShowList *stringShowList;
    SettingForConnect *settingStore;
    SettingForRuntime *settings;
}

@property (nonatomic) CGPoint point;

@end


@implementation VTSystemView

@synthesize point, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    point = [touch locationInView:self];
//    NSLog(@"touchesBegan : X = %lf, Y=%lf", point.x, point.y);
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch* touch = [touches anyObject];
//    CGPoint pt = [touch locationInView:self];
//    NSLog(@"touchesMoved : X = %lf, Y=%lf", pt.x, pt.y);
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    CGFloat slide_len = 30.0;
    
//    UIFont * font = [UIFont boldSystemFontOfSize:[settingStore fontSize]];
    UIFont * font = [settingStore getCurrentFont];
    int ix = (int)((pt.x - [settingStore leftMargin]) / ([settings getCharSizeEN:font].width + [settingStore columnSpan]));
    int iy = (int)((pt.y - [settingStore topMargin]) / ([settings getCharSizeEN:font].height + [settingStore columnSpan]));
    NSString *str;
    if (MYABS(pt.x, point.x, CLICK_LEN) && MYABS(pt.y, point.y, CLICK_LEN)) {
        //click
        NSLog(@"click!! ix = %d, iy = %d", ix, iy);
        str = [NSString stringWithFormat:@"%@%@%d%@%d%@", CUSACTIVE_CLICK_SEND, @" X=\"", ix, @"\" Y=\"", iy, @"\" />"];
    } else {
        int X = MABS(pt.x, point.x);
        int Y = MABS(pt.y, point.y);
        if (X > Y) {
            if((pt.x - point.x) > slide_len){
                //left
                str = MYKEY_LEFT;
            } else if(point.x - pt.x > slide_len){
                //right
                str = MYKEY_RIGHT;
            }
        } else {
            if(pt.y - point.y > slide_len){
                //down
                str = MYKEY_DOWN;
            } else if(point.y - pt.y > slide_len){
                //up
                str = MYKEY_UP;
            }
        }
//            NSLog(@"touchesEnded : X = %lf, Y=%lf", pt.x-point.x, pt.y-point.y);
    }
    
    [delegate handleTouchMessage:str];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch* touch = [touches anyObject];
//    CGPoint pt = [touch locationInView:self];
//    NSLog(@"touchesCancelled : X = %lf, Y=%lf", pt.x, pt.y);
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
    
    UIFont *myFont = [settingStore getCurrentFont];//[UIFont boldSystemFontOfSize:[settingStore fontSize]];
    int leftMargin = [settingStore leftMargin];
    int topMargin = [settingStore topMargin];
    int columnSpan = [settingStore columnSpan];
    int rowSpan = [settingStore rowSpan];
    
    // Get the width of a string ...
    CGSize size = [settings getCharSizeEN:myFont];
    
    for (id key in [[stringShowList stringShowDics] allKeys]) {
        NSArray *showList = [[stringShowList stringShowDics] objectForKey:key];
        
        for (ShowListEventArgs *line in showList) {
            UIColor *bgColor = settingStore.bgColor;
            UIColor *fgColor = settingStore.fgColor;
            
            [self AssignColors:line.curCharAttribute BGColor:&bgColor FGColor:&fgColor];
            CGFloat X = leftMargin + (size.width+columnSpan) * line.curPoint.x;
            CGFloat Y = topMargin + (size.height+rowSpan) * line.curPoint.y;
            
            CGSize s = CGSizeMake(size.width * (line.curCaretPos.x - line.curPoint.x), size.height);
            CGRect textRect = CGRectMake(X, Y, s.width, s.height);
            
            
            [bgColor setFill];
            CGContextFillRect(context, CGRectMake(X, Y, s.width, s.height));
            CGContextStrokePath(context);
            
            NSString * tmp = [line.curString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
//            NSLog(@"string = %@, tmp = %@, len = %d", line.curString, tmp, [tmp length]);
            if ([tmp length] < 1) {
                continue;
            }
            
            [fgColor setFill];

            //处理输出字符 带有换行符
            NSArray *array = [line.curString componentsSeparatedByString:@"\n"];
            int i = 0;
            for (NSString *str in array) {
                textRect.origin.y += i * s.height;
                i = 1;
                [str drawInRect:textRect withFont:myFont];
                
//                if (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0) {
//                    [str drawInRect:textRect withFont:myFont];
//                } else {
//                    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
//                    [attrs setObject:myFont forKey:NSFontAttributeName];
//                    [str drawInRect:textRect withAttributes:attrs];
//                }
            }
            

        }
    }
    
    //画光标
    if ([settingStore isShowCaret]) {
        CGFloat X = leftMargin + (size.width+columnSpan) * settings.caret.pos.x;
        CGFloat Y = topMargin + (size.height+rowSpan) * (settings.caret.pos.y+1)-6.0;
        [[UIColor redColor] setFill];
        CGContextFillRect(context, CGRectMake(X, Y, size.width, settingStore.cursorHeight));
        CGContextStrokePath(context);
    }
    
    myFont = nil;
}


@end
