//
//  TSBezierLineView.m
//  Pods-TSBezierPathView_Example
//
//  Created by QinChuancheng on 2019/7/18.
//

#import "TSBezierLineView.h"

@implementation TSBezierLineView

- (void)drawRect:(CGRect)rect
{
    if (self.preAxisArray.count == 0) {
        return;
    }
    
    CGRect frame = self.frame;
    
    //从左上角的坐标变成左下角坐标
    /*
     0⎢--------------> x             y⎢
     ⎢                转换成          ⎢
     ⎢               ------->        ⎢
     ⎢y                             0⎢------------>x
     */
    CGFloat axisY = 10;  //Y轴的偏移高度
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ref, 0, frame.size.height - axisY);
    CGContextScaleCTM(ref, 1, -1);
    CGContextSaveGState(ref);
    
    //绘制竖线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 0.5;
    
    //统计的数据线
    UIBezierPath *lineBezierPath = [UIBezierPath bezierPath];
    lineBezierPath.lineWidth = 2;
    
    UIBezierPath *overPath;  //小圆的曲线
    UIBezierPath *selectedBezierPath;  //大圆的曲线
    
    CGFloat axisX = self.moveAxisX;
    CGFloat yHeight = frame.size.height - 30;
    CGFloat averageY = yHeight/(CGFloat)self.maxY;
    CGPoint textPoint;
    
    for (NSUInteger index = 0; index < self.preAxisArray.count; ++index) {
        NSInteger value = [self.preAxisArray[index] integerValue];
        NSInteger valueY = [self.valueYsArray[index] integerValue];
        [bezierPath moveToPoint:CGPointMake(value/2.0 + axisX, -axisY)];
        [bezierPath addLineToPoint:CGPointMake(value/2.0 + axisX, yHeight)];
        
        UIBezierPath *ovalBezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(value/2.0 + axisX - 4, averageY * valueY - 4, 8, 8)];
        if (index == 0) {
            [lineBezierPath moveToPoint:CGPointMake(value/2.0 + axisX, averageY * valueY)];
            overPath = ovalBezierPath;
        }
        else {
            [lineBezierPath addLineToPoint:CGPointMake(value/2.0 + axisX, averageY * valueY)];
            [overPath appendPath:ovalBezierPath];
        }
        
        if (index == self.selectedIndex) {
            selectedBezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(value/2.0 + axisX - 10, averageY * valueY - 10, 20, 20)];
            textPoint = CGPointMake(value/2.0 + axisX, averageY * (self.maxY - valueY) + 30);
        }
        axisX += value;
    }
    
    [TSColor(0xEEEEEE) setStroke];
    [bezierPath stroke];
    
    [TSColor(0x61C7CB) setStroke];
    [lineBezierPath stroke];
    
    [TSColor(0x61C7CB) setFill];
    [overPath fill];
    
    [[TSColor(0x61C7CB) colorWithAlphaComponent:0.4] setFill];
    [selectedBezierPath fill];
    CGContextRestoreGState(ref);
    
    //坐标系恢复
    CGContextTranslateCTM(ref, 0, frame.size.height - axisY);
    CGContextScaleCTM(ref, 1, -1);
    NSDictionary *attr = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:20],
                           NSForegroundColorAttributeName : TSColor(0x61C7CB)
                           };
    NSAttributedString *valueAttr = [[NSAttributedString alloc] initWithString:[@([self.valueYsArray[self.selectedIndex] integerValue]) description] attributes:attr];
    CGSize size = [valueAttr size];
    [valueAttr drawAtPoint:CGPointMake(textPoint.x - size.width * 0.5, textPoint.y - size.height - 4 - 10 - axisY)];
}

- (void)showGradientLayer
{
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(0, self.frame.size.height - 10, UIScreen.mainScreen.bounds.size.width, 10);
//    gradient.colors = @[(id)[TSColor(0x3D3E64) colorWithAlphaComponent:0.1].CGColor,(id)[UIColor clearColor].CGColor];
//    gradient.startPoint = CGPointMake(0, 1);
//    gradient.endPoint = CGPointMake(0, 0);
//    [self.layer addSublayer:gradient];
}

- (void)commit
{
    [self setNeedsDisplay];
}

@end
