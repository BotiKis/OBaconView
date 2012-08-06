//
//  OBCustomItem.m
//  OBaconViewSample
//
//  Created by Botond Kis on 06.08.12.
//  Copyright (c) 2012 Botond Kis. All rights reserved.
//

#import "OBCustomItem.h"

@implementation OBCustomItem
@synthesize itemLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // backgrounds
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud-normal.png"]];
        UIImageView *selectedbackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud-selected"]];
        
        self.backgroundView = background;
        self.selectedBackgroundView = selectedbackground;
        
        // text label
        itemLabel = [[UILabel alloc] initWithFrame:frame];
        itemLabel.backgroundColor = [UIColor clearColor];
        itemLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:itemLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
