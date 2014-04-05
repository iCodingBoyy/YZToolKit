//
//  YZPainterView.m
//  YZToolKit
//
//  Created by 马远征 on 14-3-28.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZPainterView.h"

@interface YZPainterView()
{
    CGPoint _startPoint;
    CGPoint _currentPoint;
}
@end


@implementation YZPainterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect drawframe = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _drawImageView = [[UIImageView alloc]initWithFrame:drawframe];
        [self addSubview:_drawImageView];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _currentPoint = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.frame.size);
    [_drawImageView.image drawInRect:CGRectMake(0, 0, _drawImageView.frame.size.width, _drawImageView.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);//设置宽度
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);//设置颜色
	CGContextBeginPath(UIGraphicsGetCurrentContext());//开始路径
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _startPoint.x, _startPoint.y);//起始点坐标
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),_currentPoint.x, _currentPoint.y);//终点坐标
	CGContextStrokePath(UIGraphicsGetCurrentContext());//开始绘制
    
	_drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();//把图形上下文
	UIGraphicsEndImageContext();
    _startPoint = _currentPoint;
}


@end
