//  Created by Rafael Kayumov (RealPoc).
//  Copyright (c) 2013 Rafael Kayumov. License: MIT.

#import "RKTabView.h"
#import "RkTabItem.h"

#define DARKER_BACKGROUND_VIEW_TAG 33
const int RIGHT_ITEM_LENGTH =  60;
#define noDisableVerticalScrollTag 836913
#define noDisableHorizontalScrollTag 836914

@interface RKTabView ()

@property (nonatomic, strong) NSMutableArray *tabViews;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView * rightView;
@end

@implementation RKTabView
@synthesize rightView;

- (id)initWithFrame:(CGRect)frame andTabItems:(NSArray *)tabItems rightItem:(RKTabItem *)item{
    self = [super initWithFrame:frame];
    if (self) {
        self.tabItems = tabItems;
        [self setScroll];
        [self setRightItem:item];
        [self buildUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.autoresizesSubviews = YES;
    }
    return self;
}

#pragma mark - Properties

- (void) setScroll
{
    if(self.scroll)
    {
        return;
    }
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - RIGHT_ITEM_LENGTH, self.frame.size.height)];
    self.scroll.directionalLockEnabled = YES; //只能一个方向滑动
    self.scroll.pagingEnabled = YES; //是否翻页
    self.scroll.bounces = NO;  //禁止回弹
    self.scroll.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    self.scroll.indicatorStyle = UIScrollViewIndicatorStyleDefault;//滚动指示的风格
    self.scroll.showsHorizontalScrollIndicator = YES;//水平方向的滚动指示
    [self addSubview:self.scroll];
}

- (void)setTabItems:(NSArray *)tabItems {
    [self setScroll];
    _tabItems = tabItems;
    [self buildUI];
}

- (void)setHorizontalInsets:(HorizontalEdgeInsets)horizontalInsets {
    _horizontalInsets = horizontalInsets;
    [self buildUI];
}

- (NSMutableArray *)tabViews {
    if (!_tabViews) {
        _tabViews = [[NSMutableArray alloc] init];
    }
    return _tabViews;
}

- (UIFont *)titlesFont {
    if (!_titlesFont) {
        _titlesFont = [UIFont systemFontOfSize:9];
    }
    return _titlesFont;
}

- (UIColor *)titlesFontColor {
    if (!_titlesFontColor) {
        _titlesFontColor = [UIColor lightGrayColor];
    }
    return _titlesFontColor;
}

#pragma mark - Private

- (void)cleanTabView {
    for (UIControl *tab in self.tabViews) {
        [tab removeFromSuperview];
    }
    [self.tabViews removeAllObjects];
}

- (void)buildUI {
    [self showRightItem];
    //clean before layout items
    [self cleanTabView];
    //build UI
    for (RKTabItem *item in self.tabItems) {
        UIControl *tab = [self tabForItem:item];
        [self.scroll addSubview: tab];
        [self.tabViews addObject: tab];
    }
    CGSize newSize = CGSizeMake((int)(RIGHT_ITEM_LENGTH*self.tabItems.count / self.scroll.frame.size.width + 1)*self.scroll.frame.size.width, self.frame.size.height);
    [self.scroll setContentSize:newSize];
    self.scroll.tag = noDisableHorizontalScrollTag;
    [self.scroll flashScrollIndicators];
    NSLog(@"setContentSize new size = %d", (int)newSize.width);
}

- (void)swtichTab:(RKTabItem *)tabItem {
    switch (tabItem.tabType) {
        case TabTypeButton:
            //Do nothing. It has own handler and it does not affect other tabs.
            break;
        case TabTypeUnexcludable:
            //Don't exclude other tabs. Just turn this one on or off and send delegate invocation. Needs invocation for both cases on and off.
            //Switch.
            [tabItem switchState];
            [self setTabContent:tabItem];
            //Call delegate method.
            if (self.delegate) {
                switch (tabItem.tabState) {
                    case TabStateDisabled:
                        if ([self delegateRespondsToDisableSelector]) {
                            [self.delegate tabView:self tabBecameDisabledAtIndex:[self indexOfTab:tabItem] tab:tabItem];
                        }
                        break;
                    case TabStateEnabled:
                        if ([self delegateRespondsToEnableSelector]) {
                            [self.delegate tabView:self tabBecameEnabledAtIndex:[self indexOfTab:tabItem] tab:tabItem];
                        }
                        break;
                }
            }
            [self setTabContent:tabItem];
            break;
        case TabTypeUsual:
            //Exclude excludable items. Send delegate invocation.
            //Tab can we switched only if it's disabled. It can't be switched off by pressing on itself.
            if (tabItem.tabState == TabStateDisabled) {
                //Switch it on.
                [tabItem switchState];
                //Switch down other excludable items.
                for (RKTabItem *item in self.tabItems) {
                    if (item != tabItem && item.tabType == TabTypeUsual) {
                        item.tabState = TabStateDisabled;
                        [self setTabContent:item];
                    }
                }
                //Call delegate method.
                if (self.delegate) {
                    if ([self delegateRespondsToEnableSelector]) {
                        [self.delegate tabView:self tabBecameEnabledAtIndex:[self indexOfTab:tabItem] tab:tabItem];
                    }
                }
            }
            [self setTabContent:tabItem];
            break;
    }
}

#pragma mark - Actions

- (void)pressedTab:(id)sender {
    UIControl *tabView = (UIControl *)sender;
    RKTabItem *tabItem = [self tabItemForTab:tabView];
    [self swtichTab:tabItem];
}

#pragma mark - Helper methods

- (UIControl *)existingTabForTabItem:(RKTabItem *)tabItem {
    int index = [self indexOfTab:tabItem];
    if (index != NSNotFound && self.tabViews.count > index) {
        return self.tabViews[[self indexOfTab:tabItem]];
    } else {
        return nil;
    }
}

- (CGFloat)tabItemWidth {
    int itemLen = RIGHT_ITEM_LENGTH;
    CGFloat restrictedWidth = self.scroll.frame.size.width - self.horizontalInsets.left - self.horizontalInsets.right;


    @try {
        int pages = self.tabItems.count * RIGHT_ITEM_LENGTH / self.scroll.frame.size.width+1;
        if (pages > 1) {
            int pageItems = restrictedWidth / RIGHT_ITEM_LENGTH;
            CGFloat more = self.scroll.frame.size.width - pageItems*RIGHT_ITEM_LENGTH;
            itemLen += more / pageItems;
        }
    }
    @catch (NSException *exception) {
        
    }
    return self.tabItems.count > 0 ? itemLen: restrictedWidth;
}

- (CGFloat)tabItemHeight {
    return self.frame.size.height;
}

- (int)indexOfTab:(RKTabItem *)tabItem {
    return [self.tabItems indexOfObject:tabItem];
}

- (RKTabItem *)tabItemForTab:(UIControl *)tab {
    return self.tabItems[[self.tabViews indexOfObject:tab]];
}

- (CGRect)frameForTab:(RKTabItem *)tabItem {
    CGFloat width  = [self tabItemWidth];
    CGFloat height = [self tabItemHeight];
    CGFloat x = self.horizontalInsets.left + [self indexOfTab:tabItem] * width;
    NSLog(@"frameForTab X = %f, width = %f", x, width);
    return CGRectMake(x, 0, width, height);
}

-(void) showRightItem
{
    if (rightView) {
        [rightView removeFromSuperview];
    }
    rightView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - RIGHT_ITEM_LENGTH
                                                             , 0, RIGHT_ITEM_LENGTH, self.frame.size.height)];
    //Title
    UILabel *titleLabel = nil;
    CGSize titleSize;
    if (_rightItem.titleString.length != 0) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 1;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsLetterSpacingToFitWidth = YES;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        
        UIFont *font = nil;
        if (_rightItem.titleFont) {
            font = _rightItem.titleFont;
        } else if (!_rightItem.titleFont && self.titlesFont) {
            font = self.titlesFont;
        }
        titleLabel.font = font;
        
        UIColor *textColor = nil;
        if (_rightItem.titleFontColor) {
            textColor = _rightItem.titleFontColor;
        } else if (!_rightItem.titleFontColor && self.titlesFontColor) {
            textColor = self.titlesFontColor;
        }
        titleLabel.textColor = textColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        
        titleSize = [_rightItem.titleString sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(RIGHT_ITEM_LENGTH, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        titleLabel.text = _rightItem.titleString;
    }
    
    //Image/button
    id interfaceElement = nil;
    
    if (_rightItem.tabType == TabTypeButton) {
        interfaceElement = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _rightItem.imageForCurrentState.size.width, _rightItem.imageForCurrentState.size.height)];
        [((UIButton *)interfaceElement) setImage:_rightItem.imageForCurrentState forState:UIControlStateNormal];
        [((UIButton *)interfaceElement) addTarget:_rightItem.target action:_rightItem.selector forControlEvents:UIControlEventTouchUpInside];
    } else {
        interfaceElement = [[UIImageView alloc] initWithImage:_rightItem.imageForCurrentState];
    }
    ((UIView *)interfaceElement).autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    //Subviews frames
    if (titleLabel) {
        CGFloat wholeGapHeight = self.frame.size.height - ((UIView *)interfaceElement).bounds.size.height - titleSize.height;
        titleLabel.frame = CGRectMake(RIGHT_ITEM_LENGTH/2 - titleSize.width/2, wholeGapHeight*2/3+((UIView *)interfaceElement).bounds.size.height, titleSize.width+2, titleSize.height+2);
        ((UIView *)interfaceElement).frame = CGRectMake(RIGHT_ITEM_LENGTH/2 - ((UIView *)interfaceElement).bounds.size.width/2, wholeGapHeight/3, ((UIView *)interfaceElement).bounds.size.width, ((UIView *)interfaceElement).bounds.size.height);
        [rightView addSubview:titleLabel];
    } else {
        ((UIView *)interfaceElement).center = CGPointMake(RIGHT_ITEM_LENGTH/2, self.frame.size.height/2);
    }
    
    [rightView addSubview:((UIView *)interfaceElement)];
    [self addSubview:rightView];
    
}

- (void)setTabContent:(UIControl *)tab withTabItem:(RKTabItem *)tabItem {
    //clean tab before setting content
    for (UIView *subview in tab.subviews) {
        if (subview != [tab viewWithTag:DARKER_BACKGROUND_VIEW_TAG]) {
            [subview removeFromSuperview];
        }
    }
    
    //Title
    UILabel *titleLabel = nil;
    CGSize titleSize;
    if (tabItem.titleString.length != 0) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsLetterSpacingToFitWidth = YES;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        
        UIFont *font = nil;
        if (tabItem.titleFont) {
            font = tabItem.titleFont;
        } else if (!tabItem.titleFont && self.titlesFont) {
            font = self.titlesFont;
        }
        titleLabel.font = font;
        
        UIColor *textColor = nil;
        if (tabItem.titleFontColor) {
            textColor = tabItem.titleFontColor;
        } else if (!tabItem.titleFontColor && self.titlesFontColor) {
            textColor = self.titlesFontColor;
        }
        titleLabel.textColor = textColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        
        titleSize = [tabItem.titleString sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(tab.bounds.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        titleLabel.text = tabItem.titleString;
    }
    
    //Image/button
    id interfaceElement = nil;
    
    if (tabItem.tabType == TabTypeButton) {
        interfaceElement = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tabItem.imageForCurrentState.size.width, tabItem.imageForCurrentState.size.height)];
        [((UIButton *)interfaceElement) setImage:tabItem.imageForCurrentState forState:UIControlStateNormal];
        [((UIButton *)interfaceElement) addTarget:tabItem.target action:tabItem.selector forControlEvents:UIControlEventTouchUpInside];
    } else {
        interfaceElement = [[UIImageView alloc] initWithImage:tabItem.imageForCurrentState];
    }
    ((UIView *)interfaceElement).autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    //Subviews frames
    if (titleLabel) {
        CGFloat wholeGapHeight = tab.bounds.size.height - ((UIView *)interfaceElement).bounds.size.height - titleSize.height;
        titleLabel.frame = CGRectMake(tab.bounds.size.width/2 - titleSize.width/2, wholeGapHeight*2/3+((UIView *)interfaceElement).bounds.size.height, titleSize.width+2, titleSize.height+2);
        ((UIView *)interfaceElement).frame = CGRectMake(tab.bounds.size.width/2 - ((UIView *)interfaceElement).bounds.size.width/2, wholeGapHeight/3, ((UIView *)interfaceElement).bounds.size.width, ((UIView *)interfaceElement).bounds.size.height);
        [tab addSubview:titleLabel];
    } else {
        ((UIView *)interfaceElement).center = CGPointMake(tab.bounds.size.width/2, tab.bounds.size.height/2);
    }
    
    [tab addSubview:((UIView *)interfaceElement)];
    
    //backgroundColor
    if (self.darkensBackgroundForEnabledTabs) {
        if (tabItem.tabState == TabStateEnabled) {
            [tab viewWithTag:DARKER_BACKGROUND_VIEW_TAG].backgroundColor = [UIColor colorWithWhite:0 alpha:0.15f];
        } else {
            [tab viewWithTag:DARKER_BACKGROUND_VIEW_TAG].backgroundColor = [UIColor clearColor];
        }
    }
    
    //selected tab background color
    if (tabItem.tabState == TabStateEnabled) {
        
        //Apply tabItem selecred background color. If it is nil then apply tabview selected background color (if not nil).
        if (tabItem.enabledBackgroundColor) {
            tab.backgroundColor = tabItem.enabledBackgroundColor;
        } else if (!tabItem.enabledBackgroundColor && self.enabledTabBackgrondColor) {
            tab.backgroundColor = self.enabledTabBackgrondColor;
        }
    } else {
        tab.backgroundColor = [UIColor clearColor];
    }
}

- (void)setTabContent:(RKTabItem *)tabItem {
    UIControl *tab = [self tabForItem:tabItem];
    [self setTabContent:tab withTabItem:tabItem];
}

- (UIControl *)tabForItem:(RKTabItem *)tabItem {
    UIControl *tab = [self existingTabForTabItem:tabItem];
    if (tab) {
        return tab;
    } else {
        tab = [[UIControl alloc] initWithFrame:[self frameForTab:tabItem]];
        tab.backgroundColor = tabItem.backgroundColor;
        tab.autoresizesSubviews = YES;
        tab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        if (tabItem.tabType != TabTypeButton) {
            [tab addTarget:self action:@selector(pressedTab:) forControlEvents:UIControlEventTouchUpInside];
            
            //Add darker background view if necessary
            UIView *darkerBackgroundView = [[UIView alloc] initWithFrame:tab.bounds];
            darkerBackgroundView.userInteractionEnabled = NO;
            darkerBackgroundView.tag = DARKER_BACKGROUND_VIEW_TAG;
            darkerBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [tab addSubview:darkerBackgroundView];
        }
        
        //setup
        [self setTabContent:tab withTabItem:tabItem];
    }
    return tab;
}

- (BOOL)delegateRespondsToDisableSelector {
    if ([self.delegate respondsToSelector:@selector(tabView:tabBecameDisabledAtIndex:tab:)]) {
        return YES;
    } else {
        NSLog(@"Attention! Your delegate doesn't have tabView:tabBecameDisabledAtIndex:tab: method implementation!");
        return NO;
    }
}

- (BOOL)delegateRespondsToEnableSelector {
    if ([self.delegate respondsToSelector:@selector(tabView:tabBecameEnabledAtIndex:tab:)]) {
        return YES;
    } else {
        NSLog(@"Attention! Your delegate doesn't have tabView:tabBecameEnabledAtIndex:tab: method implementation!");
        return NO;
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self buildUI];
    
    self.clipsToBounds = NO;
    if (self.drawSeparators) {
        
        CGFloat darkLineWidth = 0.5f;
        CGFloat lightLineWidth = 0.5f;
        
        UIColor *darkLineColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        UIColor *lightLineColor = [UIColor colorWithWhite:0.5 alpha:0.4f];
        
        [self draWLineFromPoint:CGPointMake(0, darkLineWidth/2)
                        toPoint:CGPointMake(self.bounds.size.width, darkLineWidth/2)
                      withColor:darkLineColor
                          width:darkLineWidth];
        
        [self draWLineFromPoint:CGPointMake(0, darkLineWidth + lightLineWidth/2)
                        toPoint:CGPointMake(self.bounds.size.width, darkLineWidth + lightLineWidth/2)
                      withColor:lightLineColor
                          width:lightLineWidth];
        
        [self draWLineFromPoint:CGPointMake(0, self.bounds.size.height - darkLineWidth/2 - lightLineWidth)
                        toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - darkLineWidth/2 - lightLineWidth)
                      withColor:darkLineColor
                          width:darkLineWidth];
        
        [self draWLineFromPoint:CGPointMake(0, self.bounds.size.height - lightLineWidth/2)
                        toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - lightLineWidth/2)
                      withColor:lightLineColor
                          width:lightLineWidth];
        
        [self draWLineFromPoint:CGPointMake(self.scroll.frame.size.width, self.frame.size.height / 10)
                        toPoint:CGPointMake(self.scroll.frame.size.width, self.frame.size.height *9 / 10)
                      withColor:darkLineColor
                          width:lightLineWidth];
    }
    
//    if(self.scroll.frame.size.width > 0)
//    {
//        int pages = self.tabItems.count * RIGHT_ITEM_LENGTH / self.scroll.frame.size.width+1;
//        if(pages > 1){
//            CGFloat x = [self.scroll contentOffset].x;
//            CGFloat w = self.scroll.frame.size.width / pages;
//            int d = x / w + 1;
//            [self draWLineFromPoint:CGPointMake((d-1)*w, self.frame.size.height-2)
//                            toPoint:CGPointMake(d*w, self.frame.size.height-2)
//                          withColor:[UIColor blueColor]
//                              width:1.0F];
//        }
//    }
}

- (void)draWLineFromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo withColor:(UIColor *)color width:(CGFloat)width {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, pointFrom.x, pointFrom.y);
    CGContextAddLineToPoint(context, pointTo.x, pointTo.y);
    CGContextStrokePath(context);
}

@end
