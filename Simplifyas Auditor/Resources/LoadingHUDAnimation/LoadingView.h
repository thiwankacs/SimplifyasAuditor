//
//  LoadingView.h
//  Simplifya
//
//  Created by SCIT on 7/21/16.
//  Copyright © 2016 SCIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define loadView() \
NSBundle *mainBundle = [NSBundle mainBundle]; \
NSArray *views = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]; \
[self addSubview:views[0]];

@interface LoadingView : UIView{
     __weak IBOutlet UIImageView *imageView;
    
}

@end
