//
//  ColorNameCell.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "ColorNameCell.h"
#import "ColorName.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorNameCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel.text = nil;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel.text = nil;
    self.colorName = nil;
}

- (void)setColorName:(ColorName *)colorName
{
    _colorName = colorName;
    if (colorName != nil)
    {
        self.backgroundColor = colorName.color;
        self.nameLabel.text = colorName.name;
    }
}


@end
