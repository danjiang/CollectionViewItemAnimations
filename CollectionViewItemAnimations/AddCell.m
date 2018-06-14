//
//  AddCell.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "AddCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
}


@end
