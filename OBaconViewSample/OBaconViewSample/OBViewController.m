//
//  OBViewController.m
//  OBaconViewSample
//
//  Created by Botond Kis on 06.08.12.
//  Copyright (c) 2012 Botond Kis. All rights reserved.
//

#import "OBViewController.h"
#import "OBCustomItem.h"

@interface OBViewController ()

@end

@implementation OBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // init bacon View
    myBaconView = [[OBaconView alloc] initWithFrame:self.view.bounds];
    myBaconView.animationDirection = OBaconViewAnimationDirectionLeft;
    myBaconView.dataSource = self;
    myBaconView.delegate = self;
    
    [self.view addSubview:myBaconView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//=============================================================================
#pragma mark - baconView stuff

- (int) numberOfItemsInbaconView:(OBaconView *)baconView{
    return 20;
}

- (OBaconViewItem *) baconView:(OBaconView *)baconView viewForItemAtIndex:(int)index{
    static NSString *baconItemIdentifier = @"bacon.item";
    
    // deque baconcell
    OBCustomItem *baconItem = (OBCustomItem *)[baconView dequeueReusableItemWithIdentifier:baconItemIdentifier];
    
    // create new one if it's nil
    if (baconItem == nil) {
        baconItem = [[OBCustomItem alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    }

    // fill data
    baconItem.itemLabel.text = [NSString stringWithFormat:@"%d0x BACON!", index];
    
    return baconItem;
}

- (void) baconView:(OBaconView *)baconView didSelectItemAtIndex:(int)index{
    // show alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item selected"
                                                    message:[NSString stringWithFormat:@"%d0x BACON!", index]
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok, please leave me alone..."
                                          otherButtonTitles: nil];
    [alert show];
}


@end
