//
//  ViewController.m
//  PictureScrollViewDemo
//
//  Created by YBJ-H on 16/7/4.
//  Copyright © 2016年 YBJ-H. All rights reserved.
//

#define Width (self.view.frame.size.width - 80 *3)/4.0

#import "ViewController.h"

#import "BottomScrollView.h"
#import "TTTAttributedLabel.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong)UITableView            *tableView;
@property (nonatomic, strong)NSMutableArray         *dataSourceArray;

@property (nonatomic, strong)NSMutableArray         *imageViewArray;
@property (nonatomic, strong)BottomScrollView       *pictureScroll;

@end

@implementation ViewController

-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_tableView];
    
}


-(void)initParameter
{
    _dataSourceArray = [NSMutableArray array];
    _imageViewArray = [NSMutableArray array];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i <5; i ++) {
        int k = arc4random()%9;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%d.jpg",k]];
        [_dataSourceArray addObject:image];
        
//        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//        NSString *logPath = [NSString stringWithFormat:@"%@/crashLog.log",path];
//        NSData *data = [NSData dataWithContentsOfFile:logPath];
//        if (data) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%d.jpg",k]];
//            [_dataSourceArray addObject:image];
//        } else {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%d.jpg",k]];
//            [_dataSourceArray addObject:image];
//        }
        
    }
    
    UIImage *sourceimage = [UIImage imageNamed:@"pbg"];
    CGFloat height = sourceimage.size.height;
    CGRect rect = CGRectMake(0 + 100, 0, height, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([sourceimage CGImage], rect);
    UIImage *smallImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
    
}

-(void) test{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *logPath = [NSString stringWithFormat:@"%@/crashLog.log",path];
    NSData *data = [NSData dataWithContentsOfFile:logPath];
    if (data) {
        
        NSString *crashStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@",crashStr);
        
        //上传崩溃数据
        UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 300)];
        textview.backgroundColor = [UIColor lightGrayColor];
        textview.textColor = [UIColor blackColor];
        textview.text = crashStr;
        [self.view addSubview:textview];
        
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self initParameter];
    
    [self initTableView];
    
//    [self test];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Width +(i%3) *( Width+ 80), 10 +90*(i/3), 80, 80)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 1000 +i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = _dataSourceArray[i];
        [cell.contentView addSubview:imageView];
        
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [imageView addGestureRecognizer:tap];
    }
    
    return cell;
}

-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    
    _pictureScroll = [[BottomScrollView alloc]initWithImage:_dataSourceArray andIndex:imageView.tag - 1000 andImageView:imageView];
//    [self.view.window addSubview:_pictureScroll];
    
    [self crashMock];
}

-(void)crashMock
{
    //常见异常1---不存在方法引用
    
//        [self performSelector:@selector(thisMthodDoesNotExist) withObject:nil];
    
    //常见异常2---键值对引用nil
    
//        [[NSMutableDictionary dictionary] setObject:nil forKey:@"nil"];
    
    //常见异常3---数组越界
    
    [[NSArray array] objectAtIndex:1];
    
    //常见异常4---memory warning 级别3以上
    
//        [self performSelector:@selector(killMemory) withObject:nil];
    
//    [self performSelector:@selector(badAcess) withObject:nil];
}

-(void)killMemory
{
    for (int i = 0; i <100; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.backgroundColor = [UIColor lightGrayColor];
        label.alpha = 0.9;
        [self.view addSubview:label];
        
    }
}

-(void)badAcess
{
    UILabel *label;
    NSMutableArray *array;
    [array insertObject:label atIndex:0];
}



@end
