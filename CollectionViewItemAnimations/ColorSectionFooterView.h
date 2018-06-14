//
//  ColorSectionFooterView.h
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorSectionFooterView;

@protocol ColorSectionFooterDelegate <NSObject>

- (void)colorSectionFooterAddSectionPressed:(ColorSectionFooterView*)footerView;

@end

@interface ColorSectionFooterView : UICollectionReusableView

@property (nonatomic, assign) NSUInteger sectionIndex;
@property (nonatomic, weak) id<ColorSectionFooterDelegate> delegate;

@end
