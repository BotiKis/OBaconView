//
//  OBaconView.h
//  Aninite2012
//
//  Created by Botond Kis on 26.07.12.
//  Copyright (c) 2012 Botond Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBaconViewItem.h"
@class OBaconView;

// animation direction
typedef enum {
    OBaconViewAnimationDirectionLeft,
    OBaconViewAnimationDirectionRight
} OBaconViewAnimationDirection;

// protocol
@protocol OBaconViewDataSource <NSObject>
@required  
- (int) numberOfItemsInbaconView:(OBaconView *) baconView ;
- (OBaconViewItem *) baconView:(OBaconView *) baconView viewForItemAtIndex: (int) index;

@end

@protocol OBaconViewDelegate <NSObject>
@optional
- (void) baconView:(OBaconView *) baconView didSelectItemAtIndex: (int) index;
@end

// class
@interface OBaconView : UIView{
    id <OBaconViewDelegate> delegate;
    id <OBaconViewDataSource> dataSource;
    
    // animator
    NSTimer *animationKickStarter;
    
    // View
    UIView *baconSubview;
    
    // data
    NSMutableSet *indexStack;
    int numberOfItems;
    NSMutableArray *unusedViews;
    
    // help
    CGFloat lastPosY;
    
    // selection
    OBaconViewItem *selectedItem;
    
    // swipe gesture
    UISwipeGestureRecognizer *swag;
}
@property (nonatomic, readonly) OBaconViewItem *selectedItem;

// delegate
@property (nonatomic, strong) id <OBaconViewDelegate> delegate;

// datasource
@property (nonatomic, strong) id <OBaconViewDataSource> dataSource;
- (void)setDataSource:(id<OBaconViewDataSource>)aDataSource;

// animation stuff
@property (nonatomic, assign) NSTimeInterval animationTime;                     // default is 6s
@property (nonatomic, assign) NSTimeInterval itemAppearTime;                    // default is 2s
@property (nonatomic, assign) OBaconViewAnimationDirection animationDirection;  // default is Left
- (void)setAnimationDirection:(OBaconViewAnimationDirection)direction;

// logic
- (OBaconViewItem *) dequeueReusableItemWithIdentifier:(NSString *) identifier;
- (void) reloadData;

@end
