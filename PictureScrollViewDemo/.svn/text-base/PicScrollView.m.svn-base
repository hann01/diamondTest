//
//  PicScrollView.m
//  PictureScrollViewDemo
//
//  Created by YBJ-H on 16/7/4.
//  Copyright © 2016年 YBJ-H. All rights reserved.
//

#import "PicScrollView.h"

@interface PicScrollView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UIImageView         *_imageView;
    
    CGSize              _imageSize;
    
    CGRect              _startRect;
    
    CGRect              _endRect;
    
}

@end

@implementation PicScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self startContentView];
    }
    
    return self;
}

-(void)startContentView
{
    self.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    self.bounces = NO;
    self.minimumZoomScale = 1.0;
    self.delegate = self;
    
    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    
    tap.delegate = self;
    tapDouble.delegate = self;
    
    tap.numberOfTapsRequired = 1;
    tapDouble.numberOfTapsRequired = 2;
    
    [_imageView addGestureRecognizer:tap];
    [_imageView addGestureRecognizer:tapDouble];
    
    [tap requireGestureRecognizerToFail:tapDouble];
}


-(void)tapClick:(UITapGestureRecognizer *)tap
{
    if (tap.numberOfTapsRequired == 1) {
        if (_dismissImage) {
            _dismissImage();
        }
    } else if(tap.numberOfTapsRequired == 2){
        
        if (self.zoomScale == self.maximumZoomScale) {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        } else {
            [self setZoomScale:self.maximumZoomScale animated:YES];
        }
    }
}

-(void)setScrollContentFrame:(CGRect)rect{
    _imageView.frame = rect;
    _startRect = rect;
}

-(void)setScrollImage:(UIImage *)image{
    if (image) {
        _imageView.image = image;
        _imageSize = image.size;
        
        float scaleX = self.frame.size.width/_imageSize.width;
        float scaleY = self.frame.size.height/_imageSize.height;
        
        if (scaleX > scaleY) {
            //Y 方向先到到边界
            CGFloat imageWidth = _imageSize.width * scaleY;
            self.maximumZoomScale = self.frame.size.width/imageWidth;
            _endRect = CGRectMake((self.frame.size.width - imageWidth)/2, 0, imageWidth, self.frame.size.height);
            
            if (self.maximumZoomScale <1.5) {
                self.maximumZoomScale = 1.5;
            }
            
        } else {
            //X 方向先到达边界
            CGFloat imageHeight = _imageSize.height * scaleX;
            self.maximumZoomScale = self.frame.size.height/imageHeight;
            _endRect = CGRectMake(0, (self.frame.size.height - imageHeight)/2, self.frame.size.width, imageHeight);
            
            if (self.maximumZoomScale <1.5) {
                self.maximumZoomScale = 1.5;
            }
        }
    }
}

-(void)startAnimation{
    _imageView.frame = _endRect;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imageRect = _imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    if (imageRect.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width/2.0;
    }
    
    if (imageRect.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height/2.0;
    }
    
    _imageView.center = centerPoint;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
