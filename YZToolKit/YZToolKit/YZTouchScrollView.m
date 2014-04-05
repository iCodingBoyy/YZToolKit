//
//  YZTouchScrollView.m
//  CustomUIControl
//
//  Created by 马远征 on 14-3-24.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZTouchScrollView.h"

@implementation YZTouchScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder]touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder]touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder]touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}


//父视图是否可以将消息传递给子视图,yes是将事件传递给子视图,则不滚动,no是不传递则继续滚动

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if ([view isKindOfClass:[UITextField class]])
    {
        return YES;
    }
    return NO;
}

//Yes是子视图取消继续接受touch消息(可以滚动),NO是子视图可以继续接受touch事件(不滚动)
//默认的情况下当view不是一个UIControl类的时候,值是yes,否则是no
//调用情况是这样的一般是在发送tracking messages消息后会调用这个函数,来判断scroll是否滚动,还是接受子视图 显示进度条的touch事件

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"用户点击的视图 %@",view);
    return NO;
}
@end
