//
//  TSColumnarBezierPathView.m
//  Pods-TSBezierPathView_Example
//
//  Created by QinChuancheng on 2019/7/18.
//

#import "TSColumnarBezierPathView.h"
#import "TSBezierLineView.h"

@interface TSColumnarBezierPathView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation TSColumnarBezierPathView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    if (self.pathType == CSBezierPathTypeColumnar) {
//        [self drawColumnar];
//    }
//    else {
//        [self drawCircle];
//    }
    [self drawColumnar];
}

- (void)drawColumnar
{
    if (self.axisYValue.count == 0) {
        return;
    }
    //从左上角的坐标变成左下角坐标
    /*
     0⎢--------------> x             y⎢
     ⎢                转换成          ⎢
     ⎢               ------->        ⎢
     ⎢y                             0⎢------------>x
     
     */
    CGRect frame = self.frame;
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ref, 0, frame.size.height);
    CGContextScaleCTM(ref, 1, -1);
    CGContextSaveGState(ref);
    
    //绘图
    if (self.showType == TSShowAxisTypeX) {
        if (self.showAxisXLineCount == 0) {
            self.showAxisXLineCount = 5;
        }
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        bezierPath.lineWidth = 0.5;
        CGFloat averageYValue = (CGFloat)self.axisY/self.showAxisXLineCount;
        for (NSInteger index = 0; index < self.showAxisXLineCount; ++index) {
            [bezierPath moveToPoint:CGPointMake(self.moveAxisX, averageYValue*index ?: 0.25)];
            [bezierPath addLineToPoint:CGPointMake(frame.size.width - self.moveAxisX, averageYValue*index ?: 0.25)];
        }
        [TSColor(0xEEEEEE) setStroke];
        [bezierPath stroke];
    }
    
    CGFloat axisX = self.moveAxisX + self.columnarMoveX;
    CGFloat averageY = (CGFloat)self.axisY/self.axisYMaxValue;
    for (NSInteger index = 0; index < self.axisYValue.count; ++index) {
        CGFloat startX = axisX + index * (self.columnarSpace + self.columnarWidth);
        //绘制竖线
        if (self.showType == TSShowAxisTypeY) {
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            bezierPath.lineWidth = 0.5;
            [bezierPath moveToPoint:CGPointMake(startX + self.columnarWidth*0.5, 0)];
            [bezierPath addLineToPoint:CGPointMake(startX + self.columnarWidth*0.5, self.axisY)];
            [TSColor(0xEEEEEE) setStroke];
            [bezierPath stroke];
        }
        
        //绘制柱状图并且增加渐变
        UIBezierPath *columnarPath = [UIBezierPath bezierPath];
        columnarPath.lineWidth = 1;
        NSInteger value = [self.axisYValue[index] integerValue];
        [columnarPath moveToPoint:CGPointMake(startX, 0)];
        
        if (value == 0) {
            [columnarPath addLineToPoint:CGPointMake(startX, 5)];
            [columnarPath addLineToPoint:CGPointMake(startX + self.columnarWidth, 5)];
        }
        else {
            [columnarPath addLineToPoint:CGPointMake(startX, averageY * value - self.columnarWidth*0.5)];
            [columnarPath addArcWithCenter:CGPointMake(startX + self.columnarWidth*0.5, averageY*value - self.columnarWidth*0.5) radius:self.columnarWidth*0.5 startAngle:-M_PI endAngle:0 clockwise:NO];
        }
        [columnarPath addLineToPoint:CGPointMake(startX + self.columnarWidth, 0)];
        [columnarPath closePath];
        if (value == 0) {
            [TSColor(0xD9D9D9) setFill];
            [columnarPath fill];
        }
        else {
            [self drawLinearGradientWithPath:columnarPath.CGPath startColor:TSColor(0x9AE8E6).CGColor endColor:TSColor(0x5FC6C9).CGColor];
        }
        
//        if (self.selectedIndex == index && !self.hiddenTriangle) {
//            UIBezierPath *trianglePath = [UIBezierPath bezierPath];
//            trianglePath.lineWidth = 1;
//            [trianglePath moveToPoint:CGPointMake(startX + self.columnarWidth*0.5 - 4, 0)];
//            [trianglePath addLineToPoint:CGPointMake(startX + self.columnarWidth*0.5, 6)];
//            [trianglePath addLineToPoint:CGPointMake(startX + self.columnarWidth*0.5 + 4, 0)];
//            [trianglePath closePath];
//            [UIColor.whiteColor setFill];
//            [trianglePath fill];
//        }
    }
    CGContextRestoreGState(ref);
    
    CGContextTranslateCTM(ref, 0, frame.size.height);
    CGContextScaleCTM(ref, 1, -1);
    
    NSDictionary *attr = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:20],
                           NSForegroundColorAttributeName : TSColor(0x61C7CB)
                           };
    
    for (NSInteger index = 0; index < self.axisYValue.count; ++index) {
        
        CGFloat centerX = axisX + index * (self.columnarSpace + self.columnarWidth) + self.columnarWidth*0.5;  //文字中间位置
        CGFloat startY = frame.size.height - averageY * [self.axisYValue[index] integerValue];
        
        
        NSAttributedString *valueAttr = [[NSAttributedString alloc] initWithString:[@([self.axisYValue[index] integerValue]) description] attributes:attr];
        CGSize size = [valueAttr size];
        [valueAttr drawAtPoint:CGPointMake(centerX - size.width * 0.5, startY - size.height - 5)];
    }
}


- (void)drawCircle
{
//    if (self.maxValue <= 0) {
//        return;
//    }
//
//    CGRect frame = self.frame;
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((frame.size.width - self.radiusValue*2)*0.5, (frame.size.height - self.radiusValue*2)*0.5, self.radiusValue*2, self.radiusValue*2)];
//    circlePath.lineWidth = 20;
//    [[TSColor(0x5BCDC2) colorWithAlphaComponent:0.4] setStroke];
//    [circlePath stroke];
}

- (void)commit
{
//    if (self.pathType == CSBezierPathTypeCircle) {
//        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj removeFromSuperview];
//        }];
//        [self setNeedsDisplay];
//        UILabel *currValueLabel = UILabel.alloc.init;
//        currValueLabel.textColor = ASColorHex(0x5BCDC2);
//        currValueLabel.font = [GPTheme numberFont:30];
//        currValueLabel.text =  ASStringFormat(@"%d",(int)self.currValue);
//        [self addSubview:currValueLabel];
//        [currValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.mas_centerY).offset(0);
//            make.right.mas_equalTo(self.mas_centerX);
//        }];
//
//        UILabel *maxValueLabel = UILabel.alloc.init;
//        maxValueLabel.textColor = ASColorHex(0x888888);
//        maxValueLabel.font = [GPTheme numberFont:13];
//        maxValueLabel.text =  ASStringFormat(@"/%d",(int)self.maxValue);
//        [self addSubview:maxValueLabel];
//        [maxValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.mas_centerY).offset(-5);
//            make.left.mas_equalTo(self.mas_centerX);
//        }];
//
//        UILabel *infoLabel = UILabel.alloc.init;
//        infoLabel.textColor = ASColorHex(0x9B9B9B);
//        infoLabel.font = [GPTheme numberFont:11];
//        infoLabel.text =  NSLocalizedString(@"护肤次数/年", nil);
//        [self addSubview:infoLabel];
//        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mas_centerY).offset(5);
//            make.centerX.mas_equalTo(self.mas_centerX);
//        }];
//
//        [self animationArcPath];
//        return;
//    }
    [self setNeedsDisplay];
}

//添加曲线动画效果
- (void)animationArcPath
{
    
//    [self.superview layoutIfNeeded];
//    CGRect frame = self.frame;
//    CGFloat percentage = self.currValue/(CGFloat)self.maxValue;
//    CGFloat endAngle = M_PI * 2 * percentage - M_PI_2; //角度从-M_PI_2 -> M_PI_2 * 3 顺时针转动
//    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width*0.5, frame.size.height*0.5) radius:self.radiusValue startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
//
//    if (self.shapeLayer) {
//        [self.shapeLayer removeFromSuperlayer];
//    }
//    self.shapeLayer = [CAShapeLayer layer];
//    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    self.shapeLayer.lineWidth =  20.0f;
//    self.shapeLayer.lineCap = kCALineCapRound;
//    self.shapeLayer.strokeColor = ASColorHex(0x5BCDC2).CGColor;
//    self.shapeLayer.path = arcPath.CGPath;
//    [self.layer addSublayer:self.shapeLayer];
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.fromValue = @(0.0);
//    animation.toValue = @(1.0);
//    self.shapeLayer.autoreverses = NO;
//    animation.duration = 0.5;
//    [self.shapeLayer addAnimation:animation forKey:nil];
}

//增加渐变效果
- (void)drawLinearGradientWithPath:(CGPathRef)path
                        startColor:(CGColorRef)startColor
                          endColor:(CGColorRef)endColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    
    NSArray *colors = @[(__bridge id)startColor,(__bridge id)endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors,locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end
