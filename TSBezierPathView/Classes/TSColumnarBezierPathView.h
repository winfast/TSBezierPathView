//
//  TSColumnarBezierPathView.h
//  Pods-TSBezierPathView_Example
//
//  Created by QinChuancheng on 2019/7/18.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TSShowAxisTypeX,
    TSShowAxisTypeY,
    TSShowAxisTypeNone,
} TSShowAxisType;


@interface TSColumnarBezierPathView : UIView

/**
 x轴的偏移量
 */
@property (nonatomic) CGFloat moveAxisX;

/**
 柱状图偏移量
 */
@property (nonatomic) CGFloat columnarMoveX;

/**
 柱状图的宽
 */
@property (nonatomic) CGFloat columnarWidth;

/**
 柱状图的间距
 */
@property (nonatomic) CGFloat columnarSpace;

/**
 柱状图的最大高度
 */
@property (nonatomic) CGFloat axisYMaxValue;

/**
 y轴高度  一般情况下是小于等于view的高度
 */
@property (nonatomic) CGFloat axisY;

/**
 当前选择indexY
 */
@property (nonatomic) NSInteger selectedIndex;


/**
 y轴的数据
 */
@property (nonatomic, copy) NSArray *axisYValue;

/**
 是否显示X轴的线条
 */
@property (nonatomic) TSShowAxisType showType;

/**
 横线的条数  CSShowAxisType == CSShowAxisTypeX有效  默认5条
 */
@property (nonatomic) CGFloat showAxisXLineCount;

- (void)commit;

@end
