//
//  TSViewController.m
//  TSBezierPathView
//
//  Created by winfast on 07/18/2019.
//  Copyright (c) 2019 winfast. All rights reserved.
//

#import "TSViewController.h"
#import <TSBezierPathView/TSCenterColumnarView.h>
#import <Masonry/Masonry.h>

@interface TSViewController ()

@end

@implementation TSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    TSCenterColumnarView *view = TSCenterColumnarView.alloc.init;
    view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(225);
    }];
    
    UIView *triangleView = UIView.alloc.init;
    triangleView.backgroundColor = UIColor.whiteColor;
    [view addSubview:triangleView];
    [triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(4);
        make.width.mas_equalTo(6);
    }];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = UIColor.whiteColor.CGColor;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 3, 0);
    CGPathAddLineToPoint(path, NULL, 0, 4);
    CGPathAddLineToPoint(path, NULL, 6, 4);
    CGPathCloseSubpath(path);
    shapeLayer.path = path;
    CFRelease(path);
    triangleView.layer.mask = shapeLayer;
    
    [view layoutIfNeeded];
    
    NSArray *numbers = @[@(5),@(8),@(0),@(12),@(20),@(15),@(25),@(27),@(60),@(45),@(20),@(30),@(20),@(21)];
    
    view.pathView.moveAxisX = UIScreen.mainScreen.bounds.size.width * 0.5 - 32 * 0.5;
    view.pathView.columnarWidth = 32;
    view.pathView.axisY = view.bounds.size.height - 50;
    view.pathView.columnarSpace = 48;
    view.pathView.axisYMaxValue = ceil([[numbers valueForKeyPath:@"@max.self"] integerValue] * 1.3) + 1;
    view.pathView.showType = TSShowAxisTypeY;
    view.pathView.selectedIndex = 0;
    view.pathView.columnarMoveX = 0;
    view.pathView.axisYValue = numbers;
    [view commit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
