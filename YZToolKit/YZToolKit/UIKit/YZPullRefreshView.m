//
//  YZPullRefreshView.m
//  YZToolKit
//
//  Created by 马远征 on 14-3-28.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZPullRefreshView.h"

@interface YZPullRefreshView()
{
    NSDate *_lastUpdateDate;
}
@property (nonatomic, strong) NSDate *lastUpdateDate;
@end

@implementation YZPullRefreshView
@synthesize scrollView = _scrollView;
@synthesize delegate = _delegate;
@synthesize refreshingBlock = _refreshingBlock;
@synthesize lastUpdateDate = _lastUpdateDate;

- (id)initWithPullRefreshType:(YZPullRefreshType)type
{
    self = [super init];
    if (self)
    {
        _refreshType = type;
        [self initial];
    }
    return self;
}
- (void)initial
{
    // 1.自己的属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    // 2.时间标签
    if (_refreshType == YZPullRefreshHeader)
    {
        _updateTimelabel = [[UILabel alloc] init];
        _updateTimelabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _updateTimelabel.font = [UIFont boldSystemFontOfSize:12];
        _updateTimelabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _updateTimelabel.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        _updateTimelabel.textAlignment = NSTextAlignmentCenter;
#else
        _updateTimelabel.textAlignment = UITextAlignmentCenter;
#endif
        [self addSubview:_updateTimelabel];
    }
    
    
    // 3.状态标签
    _statuslabel = [[UILabel alloc] init];
    _statuslabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _statuslabel.font = [UIFont boldSystemFontOfSize:13];
    _statuslabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    _statuslabel.backgroundColor = [UIColor clearColor];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    _statuslabel.textAlignment = NSTextAlignmentCenter;
#else
    _statuslabel.textAlignment = UITextAlignmentCenter;
#endif
    
    [self addSubview:_statuslabel];
    
    // 4.箭头图片
    UIImage *arrowImage = [UIImage imageNamed:KArrowImage];
    _arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    _arrowImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_arrowImageView];
    
    // 5.指示器
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.bounds = _arrowImageView.bounds;
    _activityView.autoresizingMask = _arrowImageView.autoresizingMask;
    [self addSubview:_activityView];
    
    // 6.设置默认状态
    [self setState:YZPullRefreshStateNormal];
}



#pragma mark -
#pragma mark 设置刷新状态

- (void)setState:(YZPullRefreshState)state
{
    if (_state == state)
    {
        return;
    }
    _state = state;
    YZPullRefreshState _oldRefreshState = _state;
    switch (state)
    {
		case YZPullRefreshStateNormal:
        {
            _statuslabel.text = kPullToRefresh;
            _arrowImageView.hidden = NO;
			[_activityView stopAnimating];
            
            if (_refreshType == YZPullRefreshHeader && _oldRefreshState == YZPullRefreshStateRefreshing)
            {
                _lastUpdateDate = [NSDate date];
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _arrowImageView.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                if (_refreshType == YZPullRefreshHeader)
                {
                    inset.top = 0;
                }
                else
                {
                    inset.bottom = 0;
                }
                _scrollView.contentInset = inset;
            }];
            
        }
			break;
            
        case YZPullRefreshStatePulling:
        {
            _statuslabel.text = kReleaseToRefresh;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                if (_refreshType == YZPullRefreshHeader)
                {
                    inset.top = 0;
                }
                else
                {
                    inset.bottom = 0;
                }
                _scrollView.contentInset = inset;
            }];
        }
            break;
            
		case YZPullRefreshStateRefreshing:
        {
            _statuslabel.text = kRefreshing;
			[_activityView startAnimating];
			_arrowImageView.hidden = YES;
            _arrowImageView.transform = CGAffineTransformIdentity;
            
            // 通知代理
            if ([_delegate respondsToSelector:@selector(YZPullRefreshViewBeginRefreshing:)])
            {
                [_delegate YZPullRefreshViewBeginRefreshing:self];
            }
            
            // 回调
            if (_refreshingBlock)
            {
                _refreshingBlock(self);
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                UIEdgeInsets inset = _scrollView.contentInset;
                CGFloat pointY = -65.0f;
                if (_refreshType == YZPullRefreshHeader)
                {
                    inset.top = 65.0;
                }
                else
                {
                    inset.bottom = self.frame.origin.y - _scrollView.contentSize.height +65.0f;
                    CGFloat height = MAX(_scrollView.contentSize.height, _scrollView.frame.size.height);
                    pointY = height - _scrollView.frame.size.height + 65.0f;
                }
                _scrollView.contentInset = inset;
                _scrollView.contentOffset = CGPointMake(0, pointY);
            }];
            
        }
            break;
        default:
            break;
	}
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height = 65.0f;
    [super setFrame:frame];
    
    CGFloat statusY = 5;
    CGFloat w = frame.size.width;
    
    if ( w == 0 || _statuslabel.frame.origin.y == statusY )
    {
        return;
    }
    
    // 1.状态标签
    CGFloat statusX = 0;
    CGFloat statusHeight = 20;
    CGFloat statusWidth = w;
    _statuslabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    
    // 2.时间标签
    CGFloat lastUpdateY = statusY + statusHeight + 5;
    _updateTimelabel.frame = CGRectMake(statusX, lastUpdateY, statusWidth, statusHeight);
    
    // 3.箭头
    CGFloat arrowX = w * 0.5 - 100;
    _arrowImageView.center = CGPointMake(arrowX, frame.size.height * 0.5);
    
    // 4.指示器
    _activityView.center = _arrowImageView.center;
}

#pragma mark -
#pragma mark 更新刷新时间

- (void)setLastUpdateDate:(NSDate *)lastUpdateDate
{
    _lastUpdateDate = lastUpdateDate;
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateDate forKey:kRefreshTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateTimeLabel];
}

- (void)updateTimeLabel
{
    if (_lastUpdateDate == nil)
    {
        return;
    }
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateDate];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day])
    { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    }
    else if ([cmp1 year] == [cmp2 year])
    { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    }
    else
    {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:_lastUpdateDate];
    _updateTimelabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}


- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_refreshType == YZPullRefreshHeader)
    {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        self.frame = CGRectMake(0, -65.0f, scrollView.frame.size.width, 65.0f);
        
        _lastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:kRefreshTimeKey];
        [self updateTimeLabel];
    }
    else
    {
        [_scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
        [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [self adjustFrame];
    }
    
}

- (void)removeFroYZuperview
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [super removeFromSuperview];
}

- (void)adjustFrame
{
    CGFloat contentHeight = _scrollView.contentSize.height;
    CGFloat scrollHeight = _scrollView.frame.size.height;
    CGFloat y = MAX(contentHeight, scrollHeight);
    self.frame = CGRectMake(0, y, _scrollView.frame.size.width, 65.0f);
    CGPoint center = _statuslabel.center;
    center.y = _arrowImageView.center.y;
    _statuslabel.center = center;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"contentSize" isEqualToString:keyPath])
    {
        [self adjustFrame];
    }
    
    if ( [@"contentOffset" isEqualToString:keyPath] )
    {
        CGFloat offsetY = _scrollView.contentOffset.y * _refreshType;
        
        CGFloat validY = CGFLOAT_MIN;
        if (_refreshType == YZPullRefreshHeader)
        {
            validY = 0;
        }
        else
        {
            validY = MAX(_scrollView.contentSize.height, _scrollView.frame.size.height) - _scrollView.frame.size.height;
        }
        
        if ( !self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
            || _state == YZPullRefreshStateRefreshing || offsetY <= validY)
        {
            return;
        }
        
        // 即将刷新 && 手松开
        if (_scrollView.isDragging)
        {
            CGFloat validOffsetY = validY + 65.0;
            if (_state == YZPullRefreshStatePulling && offsetY <= validOffsetY)
            {
                [self setState:YZPullRefreshStateNormal];
            }
            else if (_state == YZPullRefreshStateNormal && offsetY > validOffsetY)
            {
                [self setState:YZPullRefreshStatePulling];
            }
        }
        else
        {
            if (_state == YZPullRefreshStatePulling)
            {
                [self setState:YZPullRefreshStateRefreshing];
            }
        }
    }
}


#pragma mark -
#pragma mark 返回刷新状态

- (BOOL)isRefreshing
{
    return YZPullRefreshStateRefreshing == _state;
}

#pragma mark -
#pragma mark 开始刷新

- (void)beginRefreshing
{
    [self setState:YZPullRefreshStateRefreshing];
}

#pragma mark -
#pragma mark 结束刷新

- (void)endRefreshing
{
    [self setState:YZPullRefreshStateNormal];
}

@end
