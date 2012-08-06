//
//  OBViewController.h
//  OBaconViewSample
//
//  Created by Botond Kis on 06.08.12.
//  Copyright (c) 2012 Botond Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBaconView.h"

@interface OBViewController : UIViewController <OBaconViewDataSource, OBaconViewDelegate>{
    OBaconView *myBaconView;
}

@end
