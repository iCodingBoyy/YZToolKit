//
//  YZPullRefreshView.h
//  YZToolKit
//
//  Created by 马远征 on 14-3-28.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMacroDefine.h"

#define KArrowImage @""

#define kPullToRefresh      @"上拉加载更多数据"
#define kReleaseToRefresh   @"松开即可刷新"
#define kRefreshing         @"正在刷新..."

#define kRefreshTimeKey     @"YZPullRefreshView"


typedef NS_ENUM(NSInteger, YZPullRefreshState )
{
    YZPullRefreshStateNormal = 0,
    YZPullRefreshStatePulling,
    YZPullRefreshStateRefreshing,
};

typedef NS_ENUM(NSInteger, YZPullRefreshType )
{
    YZPullRefreshHeader = -1,
    YZPullRefreshFooter = 1,
};

@class YZPullRefreshView;

typedef void (^BeginRefreshBlock)(YZPullRefreshView *refreshView);

@protocol YZPullRefreshDelegate <NSObject>

@optional
- (void)YZPullRefreshViewBeginRefreshing:(YZPullRefreshView*)refreshView;

@end

@interface YZPullRefreshView : UIView
{
    UILabel         *_statuslabel;
    UILabel         *_updateTimelabel;
    UIScrollView    *_scrollView;
    UIImageView     *_arrowImageView;
    UIActivityIndicatorView *_activityView;
    
    BeginRefreshBlock   _refreshingBlock;
    YZPullRefreshState  _state;
    YZPullRefreshType   _refreshType;
    __OBJ_WEAK id<YZPullRefreshDelegate> _delegate;
}

@property (nonatomic, copy) BeginRefreshBlock refreshingBlock;
@property (nonatomic, OBJ_WEAK) id<YZPullRefreshDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
// 是否正在刷新
@property (nonatomic, readonly, getter = isRefreshing) BOOL refreshing;
@end

