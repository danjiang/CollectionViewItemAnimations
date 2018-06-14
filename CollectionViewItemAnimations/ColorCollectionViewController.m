//
//  ColorCollectionViewController.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "ColorCollectionViewController.h"
#import "LessBoringFlowLayout.h"
#import "ColorName.h"
#import "ColorNameCell.h"
#import "AddCell.h"
#import "ColorSectionHeaderView.h"
#import "ColorSectionFooterView.h"


@interface ColorCollectionViewController () <ColorSectionHeaderDelegate, ColorSectionFooterDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * sectionedColorNames;

- (void)addNewItemInSection:(NSUInteger)section;
- (void)deleteItemAtIndexPath:(NSIndexPath*)indexPath;

- (void)insertSectionAtIndex:(NSUInteger)index;
- (void)deleteSectionAtIndex:(NSUInteger)index;

@end

@implementation ColorCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This array will contain the ColorName objects that populate the CollectionView, one array per section
    self.sectionedColorNames = [NSMutableArray arrayWithObjects:[NSMutableArray array], nil];
    
    // Allocate and configure the layout.
    LessBoringFlowLayout *layout = [[LessBoringFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 20.f;
    layout.minimumLineSpacing = 20.f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(10.f, 20.f, 10.f, 20.f);
    
    // Bigger items for iPad
    layout.itemSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGSizeMake(120, 120) : CGSizeMake(80, 80);
    
    // uncomment this to see the default flow layout behavior
    //[layout makeBoring];
    
    
    // Allocate and configure a collection view
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.bounces = YES;
    collectionView.alwaysBounceVertical = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;

    // Register reusable items
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AddCell class]) bundle:nil]
     forCellWithReuseIdentifier:NSStringFromClass([AddCell class])];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ColorNameCell class]) bundle:nil]
     forCellWithReuseIdentifier:NSStringFromClass([ColorNameCell class])];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ColorSectionHeaderView class]) bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:NSStringFromClass([ColorSectionHeaderView class])];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ColorSectionFooterView class]) bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:NSStringFromClass([ColorSectionFooterView class])];
    
    // Add to view
    [self.view addSubview:collectionView];
    
}

#pragma mark - Object insert/remove

- (void)addNewItemInSection:(NSUInteger)section
{
    ColorName *cn = [ColorName randomColorName];
    NSMutableArray *colorNames = self.sectionedColorNames[section];
    [colorNames addObject:cn];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:colorNames.count-1 inSection:section]]];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *colorNames = self.sectionedColorNames[indexPath.section];
    [colorNames removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)insertSectionAtIndex:(NSUInteger)index
{
    [self.sectionedColorNames insertObject:[NSMutableArray array] atIndex:index];
    
    // Batch this so the other sections will be updated on completion
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:index]];
    }
                                  completion:^(BOOL finished) {
                                      [self.collectionView reloadData];
                                  }];
}

- (void)deleteSectionAtIndex:(NSUInteger)index
{
    // no checking if section exists - this is somewhat unsafe
    [self.sectionedColorNames removeObjectAtIndex:index];
    
    // Batch this so the other sections will be updated on completion
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:index]];
    }
                                  completion:^(BOOL finished) {
                                      [self.collectionView reloadData];
                                  }];
    
}

#pragma mark - Header/Footer Delegates

- (void)colorSectionFooterAddSectionPressed:(ColorSectionFooterView *)footerView
{
    if (footerView.sectionIndex != NSNotFound)
    {
        [self insertSectionAtIndex:footerView.sectionIndex+1];
    }
}

- (void)colorSectionHeaderDeleteSectionPressed:(ColorSectionHeaderView *)headerView
{
    if (headerView.sectionIndex != NSNotFound)
    {
        [self deleteSectionAtIndex:headerView.sectionIndex];
    }
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionedColorNames.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Always one extra cell for the "add" cell
    NSMutableArray *sectionColorNames = self.sectionedColorNames[section];
    return sectionColorNames.count + 1;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * view = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        ColorSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:NSStringFromClass([ColorSectionHeaderView class])
                                                                                   forIndexPath:indexPath];
        header.sectionIndex = indexPath.section;
        header.hideDelete = collectionView.numberOfSections == 1; // hide when only one section
        header.delegate = self;
        view = header;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        ColorSectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                            withReuseIdentifier:NSStringFromClass([ColorSectionFooterView class])
                                                                                   forIndexPath:indexPath];
        footer.sectionIndex = indexPath.section;
        footer.delegate = self;
        view = footer;
    }
    
    return view;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    NSArray *colorNames = self.sectionedColorNames[indexPath.section];
    if (indexPath.row == colorNames.count)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AddCell class])
                                                         forIndexPath:indexPath];
    }
    else
    {
        ColorNameCell *cnCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ColorNameCell class])
                                                                          forIndexPath:indexPath];
        cnCell.colorName = colorNames[indexPath.item];
        cell = cnCell;
    }
    
    return cell;
}


#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    // only the height component is used
    return CGSizeMake(50, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    // only the height component is used
    return CGSizeMake(50, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    // Upon tapping an item, delete it. If it's the last item (the add cell), add a new one
    NSArray *colorNames = self.sectionedColorNames[indexPath.section];

    if (indexPath.item == colorNames.count)
    {
        [self addNewItemInSection:indexPath.section];
    }
    else
    {
        [self deleteItemAtIndexPath:indexPath];
    }
}


@end
