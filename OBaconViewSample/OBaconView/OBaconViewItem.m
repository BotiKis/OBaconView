//
//  OBaconViewItem.m
//  Aninite2012
//
//  Created by Botond Kis on 27.07.12.
//
//

#import "OBaconViewItem.h"

@implementation OBaconViewItem
@synthesize baconViewTag, reuseIdentifier, backgroundView, selectedBackgroundView, itemIsSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.baconViewTag = -1;
        itemIsSelected = NO;
        
        // init backgrounds
        selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
        selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self addSubview:selectedBackgroundView];
        selectedBackgroundView.hidden = YES;
        
        backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:backgroundView];
    }
    return self;
}

- (void)dealloc{
    reuseIdentifier = nil;
}

// setters
- (void)setBackgroundView:(UIView *)view{
    backgroundView = view;
    [self insertSubview:backgroundView aboveSubview:selectedBackgroundView];
}

- (void)setSelectedBackgroundView:(UIView *)view{
    selectedBackgroundView = view;
    [self addSubview:selectedBackgroundView];
    selectedBackgroundView.hidden = YES;
    [self sendSubviewToBack:selectedBackgroundView];
}

- (void)setItemIsSelected:(BOOL)selected{
    itemIsSelected = selected;
    
    if (selected) {
        [self insertSubview:selectedBackgroundView aboveSubview:backgroundView];
        selectedBackgroundView.hidden = NO;
    }
    else{
        [self sendSubviewToBack:selectedBackgroundView];
        selectedBackgroundView.hidden = YES;
    }
}

@end
