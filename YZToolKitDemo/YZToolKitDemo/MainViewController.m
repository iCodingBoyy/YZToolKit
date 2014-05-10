//
//  MainViewController.m
//  YZToolKitDemo
//
//  Created by 马远征 on 14-5-9.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "MainViewController.h"
#import <YZToolKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MainViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetlibrary;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (ALAssetsLibrary*)assetlibrary
{
    if (_assetlibrary == nil)
    {
        _assetlibrary = [[ALAssetsLibrary alloc]init];
    }
    return _assetlibrary;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 80, 44)];
    [button setCenter:CGPointMake(160, 240)];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [button setTitle:@"photo" forState:UIControlStateNormal];
    [button setTitle:@"photo" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick
{
    YZPhotoAlumViewController *phoneAlbumVC = [[YZPhotoAlumViewController alloc]initWithAssetLibrary:self.assetlibrary];
    UINavigationController *navgationController = [[UINavigationController alloc]initWithRootViewController:phoneAlbumVC];
    [self.navigationController presentModalViewController:navgationController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
