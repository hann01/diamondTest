//
//  BottomScrollView.m
//  PictureScrollViewDemo
//
//  Created by YBJ-H on 16/7/4.
//  Copyright © 2016年 YBJ-H. All rights reserved.
//

#import "BottomScrollView.h"

#import "PicScrollView.h"

@implementation BottomScrollView

-(instancetype)initWithImage:(NSArray *)imageArray andIndex:(NSInteger)index andImageView:(UIImageView *)imageView{
    
    UIWindow *win = [[UIApplication sharedApplication]keyWindow];
    self = [super initWithFrame:win.frame];
    if (self) {
        [self initViewWithImage:imageArray andIndex:index andImageView:imageView and:win.frame];
    }
    
    return self;
}

-(void)initViewWithImage:(NSArray *)imageArray andIndex:(NSInteger)index andImageView:(UIImageView *)imageView and:(CGRect)rect
{
    UIWindow *win = [[UIApplication sharedApplication]keyWindow];
    self.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    self.contentSize = CGSizeMake(rect.size.width * imageArray.count, rect.size.height);
    self.contentOffset = CGPointMake(rect.size.width * index, 0);
    self.pagingEnabled = YES;
    
    CGRect convertRect = [imageView.superview convertRect:imageView.frame toView:win];
    __weak typeof (self) weakSelf = self;
    for (int i = 0; i < 5; i ++) {
        
       PicScrollView *picScroll = [[PicScrollView alloc]initWithFrame:CGRectMake(self.bounds.size.width * i, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [self addSubview:picScroll];
        [picScroll setScrollContentFrame:convertRect];
        [picScroll setScrollImage:imageArray[i]];
        [picScroll startAnimation];
        picScroll.dismissImage = ^{
            [weakSelf removeFromSuperview];
        };
    }
}


@end
