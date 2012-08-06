//
//  OBaconViewItem.h
//  Aninite2012
//
//  Created by Botond Kis on 27.07.12.
//
//

#import <UIKit/UIKit.h>

@interface OBaconViewItem : UIView{
    UIView *selectedBackgroundView;
    UIView *backgroundView;
}
@property (nonatomic, assign) NSInteger baconViewTag;
@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, strong) UIView *backgroundView;
- (void)setBackgroundView:(UIView *)view;

@property (nonatomic, strong) UIView *selectedBackgroundView;
- (void)setSelectedBackgroundView:(UIView *)view;

@property (nonatomic, assign) BOOL itemIsSelected;
- (void)setItemIsSelected:(BOOL)selected;

@end
