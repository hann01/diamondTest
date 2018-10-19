//
//  PicScrollView.h
//  PictureScrollViewDemo
//
//  Created by YBJ-H on 16/7/4.
//  Copyright © 2016年 YBJ-H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicScrollView : UIScrollView

@property (nonatomic, copy)void (^dismissImage)();

-(void)setScrollContentFrame:(CGRect)rect;

-(void)setScrollImage:(UIImage *)image;

-(void)startAnimation;

@end
