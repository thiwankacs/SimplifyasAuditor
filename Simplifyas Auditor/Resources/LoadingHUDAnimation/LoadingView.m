//
//  LoadingView.m
//  Simplifya
//
//  Created by SCIT on 7/21/16.
//  Copyright © 2016 SCIT. All rights reserved.
//

#import "LoadingView.h"
#import "UIImage+animatedGIF.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    loadView()
    [self setImage];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    loadView()
    return self;
}

-(void)setImage{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"anim" withExtension:@"gif"];
    imageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
}

@end
