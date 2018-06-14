//
//  ColorSectionFooterView.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "ColorSectionFooterView.h"

@interface ColorSectionFooterView ()

- (IBAction)addSectionPressed:(id)sender;


@end

@implementation ColorSectionFooterView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _sectionIndex = NSNotFound;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _sectionIndex = NSNotFound;
}

- (IBAction)addSectionPressed:(id)sender
{
    [self.delegate colorSectionFooterAddSectionPressed:self];
}

@end
