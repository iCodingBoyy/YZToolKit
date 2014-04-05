//
//  YZHypnosisView.m
//  CustomUIControl
//
//  Created by 马远征 on 14-3-24.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZHypnosisView.h"

@implementation YZHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGPoint center;
    center.x = rect.origin.x + rect.size.width * 0.5;
    center.y = rect.origin.y + rect.size.height * 0.5;
    
    CGFloat maxRadius = hypotf(rect.size.width , rect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    [[UIColor orangeColor]setFill];
    
    for (CGFloat crrRadius = maxRadius; crrRadius > 0 ; crrRadius -= 20)
    {
        CGContextAddArc(context, center.x, center.y, crrRadius, 0.0, M_PI*2.0, YES);
        CGContextStrokePath(context);
    }
}

@end
