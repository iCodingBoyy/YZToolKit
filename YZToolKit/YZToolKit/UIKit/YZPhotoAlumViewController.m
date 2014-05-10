//
//  YZPhotoAlumViewController.m
//  YZToolKit
//
//  Created by 马远征 on 14-5-8.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZPhotoAlumViewController.h"


static const CGFloat KTableViewCellHeight = 60.0;

@interface YZPhotoAlumViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assetGroupArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSObject *syncObject;
@end

@implementation YZPhotoAlumViewController

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _assetLibrary = nil;
    _assetGroupArray = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark init

- (id)initWithAssetLibrary:(ALAssetsLibrary *)library
{
    self = [super init];
    if (self)
    {
        _assetLibrary = library;
    }
    return self;
}

- (NSObject*)syncObject
{
    if (_syncObject)
    {
        return _syncObject;
    }
    _syncObject = [[NSObject alloc]init];
    return _syncObject;
}

- (NSMutableArray*)assetGroupArray
{
    if (_assetGroupArray == nil)
    {
        _assetGroupArray = [[NSMutableArray alloc]init];
    }
    return _assetGroupArray;
}

- (UITableView*)tableView
{
    if (_tableView == nil)
    {
        CGRect bounds = [[UIScreen mainScreen]bounds];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark -
#pragma mark loadView

- (void)loadView
{
    [super loadView];
    
    UIView *contentView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    contentView = nil;
}

- (void)replaceWithNewObjects:(NSArray*)array
{
    @synchronized(_assetGroupArray)
    {
        if ( self.assetGroupArray && array)
        {
            
            if (_assetGroupArray.count > 0)
            {
                [_assetGroupArray removeAllObjects];
            }
            
            [_assetGroupArray addObjectsFromArray:array];
        }
    }
}

- (void)EnumeratorPhotoAlbums
{
    if (_assetLibrary == nil) return;
    
    __block NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    
    void (^assetGroupEnumerator)(ALAssetsGroup *,BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group == nil)
        {
            [self replaceWithNewObjects:tmpArray];
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            return ;
        }
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if ([group numberOfAssets] > 0)
        {
            [tmpArray addObject:group];
        }
    };
    
    void (^assetGroupEnumeratorFailure)(NSError*) = ^(NSError *error)
    {
        if ([error.domain isEqualToString:ALAssetsLibraryErrorDomain])
        {
            switch (error.code)
            {
                case ALAssetsLibraryAccessUserDeniedError:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
    };
    
    ALAssetsGroupType groupType = (ALAssetsGroupSavedPhotos | ALAssetsGroupAlbum | ALAssetsGroupLibrary);
    [self.assetLibrary enumerateGroupsWithTypes:groupType
                                     usingBlock:assetGroupEnumerator
                                   failureBlock:assetGroupEnumeratorFailure];
    
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // 监听相册对象改变（添加或者删除）
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(assetLibraryDidChange:)
                                                name:ALAssetsLibraryChangedNotification
                                              object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self registerNotification];
    [self EnumeratorPhotoAlbums];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)assetLibraryDidChange:(NSNotification*)changeNotification
{
    NSLog(@"----assetLibraryDidChange--");
    [self EnumeratorPhotoAlbums];
}

#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _assetGroupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KTableViewCellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < _assetGroupArray.count)
    {
        ALAssetsGroup *assetGroup = [_assetGroupArray objectAtIndex:indexPath.row];
        [assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        cell.imageView.image = [UIImage imageWithCGImage:[assetGroup posterImage]];
        
        NSInteger assetGroupCount = [assetGroup numberOfAssets];
        NSString *albumName = [assetGroup valueForProperty:ALAssetsGroupPropertyName];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",albumName,(long)assetGroupCount];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
