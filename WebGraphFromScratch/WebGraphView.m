//
//  WebGraphView.m
//  WebGraphFromScratch
//
//  Created by Kumaraswamy on 02/03/16.
//  Copyright © 2016 Razorthink. All rights reserved.
//

#import "WebGraphView.h"

@interface WebGraphView()
@property (nonatomic,strong) NSMutableDictionary * valuesDictionary;
@property NSMutableArray *pointsLengthArrayArray,*pointsToPlotArray;
@property float maxVlue, spaceValue, centerX,centerY,valueDivider;
@property (nonatomic , strong)   UILabel *sectionLabel ;
@end

@implementation WebGraphView
-(id)initWithFrame:(CGRect)frame withDictionaryValues:(NSDictionary *)valuesDictionary withMaxValue:(CGFloat)maxValue
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _valuesDictionary = [valuesDictionary mutableCopy];
        _pointsLengthArrayArray = [NSMutableArray array];
        _pointsToPlotArray = [NSMutableArray array];
        _maxVlue = (float)maxValue;
        _spaceValue = 27.0;
        [self createWebGarph];
    }
    return  self;
  }

-(void)createWebGarph{
    
    [self calculatePoints];
    
}
-(void)calculatePoints{
   
    CGFloat boundWidth = self.bounds.size.width;
    CGFloat boundHeight =  self.bounds.size.height;
    _centerX = (float)boundWidth/2;
    _centerY = (float)boundHeight/2;
     _valueDivider = 1;
    
    NSArray *keyArray = [_valuesDictionary allKeys];
    NSLog(@"%@",keyArray);
    NSArray *valueArray = [self getValueArrayFromDictionary:_valuesDictionary keyArray:keyArray];
    _maxVlue = [self getMaxValueFromValueArray:valueArray];
    NSLog(@"max %f",_maxVlue);
    NSArray *angleArray = [self getAngleArrayFromNumberOfSection:(int)[keyArray count]];
    CGFloat maxLength = MIN(boundWidth, boundHeight) *0.33;
    int plotCircles = (_maxVlue/_valueDivider);
    CGFloat lengthUnit = maxLength/plotCircles;
    NSArray *lengthArray = [self getLengthArrayWithLengthUnit:lengthUnit maxLength:maxLength];
    
    //get all the points and plot
    for (NSNumber *lengthNumber in lengthArray)
    {
        CGFloat length = [lengthNumber floatValue];
        [_pointsLengthArrayArray addObject:[self getPlotPointWithLength:length angleArray:angleArray]];
    }
    int section = 0;
    for (id value in valueArray)
    {
        CGFloat valueFloat = [value floatValue];
        CGFloat length = valueFloat/_maxVlue * maxLength;
        CGFloat angle = [[angleArray objectAtIndex:section] floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        [_pointsToPlotArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        section++;
    }
    
    [self drawLabelWithMaxLength:maxLength labelArray:keyArray angleArray:angleArray];
    
}


- (void)drawRect:(CGRect)rect
{
    int i=0;
  
            for (NSArray *pointArray in _pointsLengthArrayArray)
            {
            CGContextRef graphContext = UIGraphicsGetCurrentContext();
            CGContextBeginPath(graphContext);
            CGPoint beginPoint = [[pointArray objectAtIndex:0] CGPointValue];
            CGContextMoveToPoint(graphContext, beginPoint.x, beginPoint.y);
            for (NSValue* pointValue in pointArray){
                CGPoint point = [pointValue CGPointValue];
                CGContextAddLineToPoint(graphContext, point.x, point.y);
            }
            CGContextAddLineToPoint(graphContext, beginPoint.x, beginPoint.y);
            if(i==_pointsLengthArrayArray.count-1){
            CGContextSetLineWidth(graphContext, 2);
            }
            else{
                CGContextSetLineWidth(graphContext, 0.7);
            }

            CGContextSetStrokeColorWithColor(graphContext, [UIColor blackColor].CGColor);
            CGContextStrokePath(graphContext);
            i++;
            }

            NSArray *largestPointArray = [_pointsLengthArrayArray lastObject];
            for (NSValue* pointValue in largestPointArray){
                CGContextRef graphContext = UIGraphicsGetCurrentContext();
                CGContextBeginPath(graphContext);
                CGContextMoveToPoint(graphContext, _centerX, _centerY);
                CGPoint point = [pointValue CGPointValue];
                CGContextAddLineToPoint(graphContext, point.x, point.y);
                 CGContextSetLineWidth(graphContext, 1);
                CGContextSetStrokeColorWithColor(graphContext, [UIColor blackColor].CGColor);
                CGContextStrokePath(graphContext);
            }
    
            CGContextRef graphContext = UIGraphicsGetCurrentContext();
            CGContextBeginPath(graphContext);
            CGPoint beginPoint = [[_pointsToPlotArray objectAtIndex:0] CGPointValue];
            CGContextMoveToPoint(graphContext, beginPoint.x, beginPoint.y);
            for (NSValue* pointValue in _pointsToPlotArray){
                CGPoint point = [pointValue CGPointValue];
                CGContextAddLineToPoint(graphContext, point.x, point.y);
            }
            CGContextAddLineToPoint(graphContext,beginPoint.x, beginPoint.y);
            CGContextSetStrokeColorWithColor(graphContext, [UIColor redColor].CGColor);
            CGContextSetLineWidth(graphContext, 3);
            CGContextSetFillColorWithColor(graphContext, [UIColor colorWithRed:.8 green:.4 blue:.3 alpha:.7].CGColor);
            CGContextDrawPath(graphContext, kCGPathFillStroke);
   
}

#pragma mark - Helper Function

- (NSArray *)getAngleArrayFromNumberOfSection:(int)numberOfSection
{
    NSMutableArray *angleArray = [NSMutableArray array];
    for (int section = 0; section < numberOfSection; section++) {
        NSLog(@"angles   %@",[NSNumber numberWithFloat:(float)section/(float)[_valuesDictionary count]* 2*M_PI ]);
        [angleArray addObject:[NSNumber numberWithFloat:(float)section/(float)[_valuesDictionary count] * 2*M_PI]];
    }
    return angleArray;
}

- (NSArray *)getValueArrayFromDictionary:(NSDictionary *)dictionary keyArray:(NSArray *) keyArray
{
     NSMutableArray *valueArray = [NSMutableArray array];
    for(NSString *key in keyArray){
         CGFloat value = [[_valuesDictionary objectForKey:key]floatValue];
        [valueArray addObject:[NSNumber numberWithFloat:value]];
    }
    return valueArray;
}

- (CGFloat)getMaxValueFromValueArray:(NSArray *)valueArray
{
    CGFloat maxValue = _maxVlue;
    for (NSNumber *valueNumber in valueArray) {
        CGFloat valueFloat = [valueNumber floatValue];
        maxValue = valueFloat>maxValue?valueFloat:maxValue;
    }
    return ceilf(maxValue);
}

- (NSArray *)getPlotPointWithLength:(CGFloat)length angleArray:(NSArray *)angleArray
{
    NSMutableArray *pointArray = [NSMutableArray array];
    //each length find the point
    for (NSNumber *angleNumber in angleArray) {
        
        NSLog(@"%f",length);
        CGFloat angle = [angleNumber floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    return pointArray;
}
- (NSArray *)getLengthArrayWithLengthUnit:(CGFloat)lengthUnit maxLength:(CGFloat)maxLength
{
    NSMutableArray *lengthArray = [NSMutableArray array];
    for (CGFloat length = lengthUnit; length <= maxLength; length += lengthUnit) {
        [lengthArray addObject:[NSNumber numberWithFloat:length]];
    }
    return lengthArray;
}

- (void)drawLabelWithMaxLength:(CGFloat)maxLength labelArray:(NSArray *)labelArray angleArray:(NSArray *)angleArray
{

    int section = 0;
    CGFloat fontSize = (maxLength/10)*5/4;
    CGFloat labelLength = maxLength + maxLength/10;
    for (NSString *labelString in labelArray) {
        CGFloat angle = [[angleArray objectAtIndex:section] floatValue];
        CGFloat x = _centerX + labelLength*cos(angle);
        CGFloat y = _centerY + labelLength*sin(angle);
      
        NSLog(@"%f,%f",y,_centerY);
        if(ceilf(x)  >= _centerX)
        {
                 _sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(x - 5*fontSize/2+35, y - fontSize/2, 5*fontSize, fontSize)];
            
        }
        
        else
        {
            _sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(x - 5*fontSize/2-15, y - fontSize/2, 5*fontSize, fontSize)];
          
        }
        
        
        _sectionLabel.backgroundColor = [UIColor clearColor];
        _sectionLabel.font = [UIFont systemFontOfSize:fontSize];
        _sectionLabel.textAlignment = NSTextAlignmentRight;
        _sectionLabel.text = labelString;
       
        [_sectionLabel sizeToFit];
        [self addSubview: _sectionLabel];
        section++;
    }
}


@end
