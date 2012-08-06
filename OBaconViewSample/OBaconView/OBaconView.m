//
//  OBaconView.m
//  Aninite2012
//
//  Created by Botond Kis on 26.07.12.
//  Copyright (c) 2012 Botond Kis. All rights reserved.
//

#import "OBaconView.h"
#import <math.h>
#import <QuartzCore/QuartzCore.h>

@interface OBaconView ()
- (void) animationKickStartTimerTick:(NSTimer *)timer;
- (void) rebuildIndexStack;
- (void) fireAnimationTimerWithTime:(NSTimeInterval)time;

// swipe gesture
- (void) swipeDetected:(UISwipeGestureRecognizer *)gesture;
- (void)resetAnimationTime;
@end

// Time definitionss
#define kOBaconView_DefaultAnimationTime 6.0f
#define kOBaconView_DefaultAnimationTimeDivisor 2.0f

@implementation OBaconView
@synthesize delegate, dataSource, selectedItem;
@synthesize animationTime, itemAppearTime, animationDirection;

//==========================================================
#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init important stuff
        indexStack = [[NSMutableSet alloc] init];
        
        baconSubview = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:baconSubview];
        
        unusedViews = [[NSMutableArray alloc] init];
        
        self.multipleTouchEnabled = NO;
        
        lastPosY = -1;
        
        // default times
        self.animationTime = kOBaconView_DefaultAnimationTime;
        self.itemAppearTime = kOBaconView_DefaultAnimationTimeDivisor;
        self.animationDirection = OBaconViewAnimationDirectionLeft;
        
        // Swipe gesture
        swag = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
        [swag setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swag];
    }
    return self;
}

- (void) dealloc{
    delegate = nil;
    dataSource = nil;
    
    baconSubview = nil;
    indexStack = nil;
    
    unusedViews = nil;
}


//==========================================================
#pragma mark - Properties
- (void)setDataSource:(id<OBaconViewDataSource>)aDataSource{
    dataSource = aDataSource;
    [self reloadData];
}


//==========================================================
#pragma mark - Logic

- (OBaconViewItem *) dequeueReusableItemWithIdentifier:(NSString *) identifier{
    
    OBaconViewItem *itemToDequeue = nil;
    
    // get an unused view if available
    if ([unusedViews count] > 0) {
        for (OBaconViewItem *item in unusedViews) {
            if ([item.reuseIdentifier isEqualToString:identifier]) {
                itemToDequeue = item;
                [unusedViews removeObject:item];
                break;
            }
        }
    }
    
    return itemToDequeue;
}

- (void) reloadData{
    // kill timer
    [animationKickStarter invalidate];
    animationKickStarter = nil;
    
    // remove all bacon subview
    for (OBaconViewItem *item in baconSubview.subviews) {
        CGFloat origAlpha = item.alpha;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             item.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             item.alpha = origAlpha;
                             [unusedViews addObject:item];
                             [item removeFromSuperview];
                         }
         ];
    }
    
    
    // empty stack
    [indexStack removeAllObjects];
    
    // build index stack
    // Don't do any integrity checks here becaus this method is MANDATORY
    numberOfItems = [dataSource numberOfItemsInbaconView:self];
    [self rebuildIndexStack];
    
    // restart timer
    [self fireAnimationTimerWithTime:self.animationTime/self.itemAppearTime];
}


- (void) rebuildIndexStack{
    for (int i = 0; i < numberOfItems; i++) {
        [indexStack addObject: [NSNumber numberWithInt:i]];
    }
}


- (void) fireAnimationTimerWithTime:(NSTimeInterval)time{
    [animationKickStarter invalidate];
    animationKickStarter = nil;
    
    // get timer
    animationKickStarter = [NSTimer scheduledTimerWithTimeInterval:time
                                                            target:self
                                                          selector:@selector(animationKickStartTimerTick:)
                                                          userInfo:nil
                                                           repeats:YES];
    [animationKickStarter fire];
}


- (void)setAnimationDirection:(OBaconViewAnimationDirection)direction{
    animationDirection = direction;
    
    if (direction == OBaconViewAnimationDirectionLeft) {
        [swag setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    else{
        [swag setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    
    [self reloadData];
}


//==========================================================
#pragma mark - Animation Timer

- (void) animationKickStartTimerTick:(NSTimer *)timer{
    // safety check if indexStack is really empty at start
    if ([indexStack count] == 0) {
        [animationKickStarter invalidate];
        animationKickStarter = nil;
        return;
    }
    
    // get random item
    NSNumber *currentIndex = [indexStack anyObject];
    
    // remove from indexStack
    [indexStack removeObject:currentIndex];
    
    if ([indexStack count] == 0) {
        // rebuild index stack
        [self rebuildIndexStack];
    }
    
    // Don't do any integrity checks here becaus this method is MANDATORY
    // It SHALL crash if developer is too dumb to implement it,
    OBaconViewItem *userItem = [dataSource baconView:self viewForItemAtIndex:[currentIndex intValue]];
    userItem.baconViewTag = [currentIndex intValue];
    
    /////////
    //layout
    // positions
    CGFloat posX;
    CGFloat posY;
    
    if (self.animationDirection == OBaconViewAnimationDirectionLeft) {
        posX = self.bounds.size.width;
    }
    else{
        posX = -userItem.frame.size.width;
    }
    
    // randomate y position of Item but not in the near of the last item
    int randPosY;
    do {
        randPosY = abs(arc4random() % (int)(self.bounds.size.height-userItem.frame.size.height));
    } while (randPosY < (lastPosY + userItem.frame.size.height - 20) && randPosY > (lastPosY - userItem.frame.size.height + 20));
    lastPosY = (CGFloat)randPosY;
    
    // set frame
    posY = randPosY;
    userItem.frame = CGRectMake(posX, posY, userItem.frame.size.width, userItem.frame.size.height);
    
    // add to subview
    [baconSubview addSubview:userItem];
    
    ///////////
    //animation
    // random animation time
    int randAnimTime = arc4random()%26;
    NSTimeInterval actualAnimationTime = self.animationTime + ((float)randAnimTime)/5.0f;
    
    // animate
    CGFloat animatedXPos;
    
    if (self.animationDirection == OBaconViewAnimationDirectionLeft) {
        animatedXPos = -userItem.frame.size.width;
    }
    else{
        animatedXPos = self.bounds.size.width;
    }
    
    [UIView animateWithDuration:actualAnimationTime
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         userItem.frame = CGRectMake(animatedXPos, userItem.frame.origin.y, userItem.frame.size.width, userItem.frame.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         [unusedViews addObject:userItem];
                         [userItem removeFromSuperview];
                     }
     ];
}


//==========================================================
#pragma mark - Touch handling

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:baconSubview];
    
    // find touched view
    for (OBaconViewItem *bi in baconSubview.subviews) {
        CALayer *presentationLayer = bi.layer.presentationLayer;
        if ([presentationLayer hitTest:touchPoint]) {
            
            // bring to front
            [baconSubview bringSubviewToFront:bi];
            
            // set selectedItem
            selectedItem = bi;
            
            // make a press
            selectedItem.itemIsSelected = YES;
            
            break;
        }
    }
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:baconSubview];
    
    CALayer *presentationLayer = selectedItem.layer.presentationLayer;
    if ([presentationLayer hitTest:touchPoint]) {
        selectedItem.itemIsSelected = YES;
    }
    else{
        selectedItem.itemIsSelected = NO;
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:baconSubview];
    
    // end press
    selectedItem.itemIsSelected = NO;
    
    // find touched view
    for (OBaconViewItem *bi in baconSubview.subviews) {
        CALayer *presentationLayer = bi.layer.presentationLayer;
        if ([presentationLayer hitTest:touchPoint]) {
            
            // tell delegate touched item.
            if (bi == selectedItem && [delegate respondsToSelector:@selector(baconView:didSelectItemAtIndex:)]) {
                [delegate baconView:self didSelectItemAtIndex:bi.baconViewTag];
            }
            break;
        }
    }
    
    selectedItem = nil;
}


//=============================================================================
#pragma mark - swipe gesture
- (void)swipeDetected:(UISwipeGestureRecognizer *)gesture{
    selectedItem.selectedBackgroundView.hidden = YES;
    
    self.layer.timeOffset = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 10.0;
    self.layer.beginTime = CACurrentMediaTime();
    
    // start new timer
    [self fireAnimationTimerWithTime:self.animationTime/(self.itemAppearTime*self.layer.speed)];
    
    [self performSelector:@selector(resetAnimationTime) withObject:nil afterDelay:0.4];
}

- (void)resetAnimationTime{
    self.layer.timeOffset = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 1.0;
    self.layer.beginTime = CACurrentMediaTime()-0.4;
    
    // start orig timer
    [self fireAnimationTimerWithTime:self.animationTime/self.itemAppearTime];
}

@end