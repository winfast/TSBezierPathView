//
//  TSBezierLineView.h
//  Pods-TSBezierPathView_Example
//
//  Created by QinChuancheng on 2019/7/18.
//

#import <UIKit/UIKit.h>

#define TSColor(hexNumber)   [UIColor colorWithRed:(((float)((hexNumber & 0xFF0000) >> 16)) / 255.0) \
green:(((float)((hexNumber & 0xFF00) >> 8)) / 255.0) \
blue:(((float)(hexNumber & 0xFF)) / 255.0) alpha:1]


@interface TSBezierLineView : UIView

@property (nonatomic, strong) NSArray *preAxisArray;  //每一条数据需要的x宽度 最后竖线绘制在中间
@property (nonatomic, copy) NSArray *valueYsArray;     //数据数组
@property (nonatomic) NSInteger maxY;     //Y轴最大值
@property (nonatomic) NSInteger selectedIndex;   //默认选择第0个
@property (nonatomic) CGFloat moveAxisX;   //x偏移量

//设置好数据后开始绘制UI
- (void)commit;

- (void)showGradientLayer;

@end
