//
//  TSCenterColumnarView.h
//  Pods-TSBezierPathView_Example
//
//  Created by QinChuancheng on 2019/7/18.
//

#import <UIKit/UIKit.h>
#import "TSColumnarBezierPathView.h"

@interface TSCenterColumnarView : UIView

@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) TSColumnarBezierPathView *pathView;
@property (nonatomic, copy) void (^selectedcolumnar)(NSInteger index);
@property (assign, nonatomic) NSInteger type;

//需要显示的label的内容
@property (nonatomic, strong) NSArray *labelTextsArray;

- (void)commit;

- (void)scrollerToCenter:(BOOL)animate;

@end

/*
 demo
 
 _clockDataView = [[CSClockDataView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, kAdaptedWidth(225))];
 _clockDataView.backgroundColor = [UIColor whiteColor];
 [self addSubview:_clockDataView];
 [_clockDataView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.left.right.equalTo(self);
 make.height.mas_equalTo(kAdaptedWidth(225));
 }];

 - (void)drawViewWithNumbers:(NSArray<NSString *> *)numbers {
 [self layoutIfNeeded];
 [self.clockDataView.pathView layoutIfNeeded];
// if (type == CSBezierPathTypeColumnar) {
 self.clockDataView.pathView.pathType = CSBezierPathTypeColumnar;
 self.clockDataView.pathView.moveAxisX = GPBounds.screenW * 0.5 - 32 * 0.5;  //让第一个有居中的效果
 self.clockDataView.pathView.columnarWidth = 32;
 self.clockDataView.pathView.axisY = self.clockDataView.bounds.size.height - 50;
 self.clockDataView.pathView.columnarSpace = 48;
 self.clockDataView.pathView.maxY = ceil([[numbers valueForKeyPath:@"@max.self"] integerValue] * 1.1) + 1;
 self.clockDataView.pathView.showType = CSShowAxisTypeY;
 self.clockDataView.pathView.selectedIndex = self.selelctedIndex;
 self.clockDataView.pathView.columnarMoveX = 0;
 self.clockDataView.pathView.axisYValue = numbers;
 [self.clockDataView commit];
// } else {
// self.clockDataView.pathView.pathType = CSBezierPathTypeCircle;
 //self.clockDataView.pathView.maxValue = [numbers.firstObject integerValue];
// self.clockDataView.pathView.currValue = [numbers.lastObject integerValue];
// self.clockDataView.pathView.radiusValue = 80;
 [self.clockDataView commit];
 }
 }

 
 */
