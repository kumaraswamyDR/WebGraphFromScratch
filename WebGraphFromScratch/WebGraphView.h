//
//  WebGraphView.h
//  WebGraphFromScratch
//
//  Created by Kumaraswamy on 02/03/16.
//  Copyright © 2016 Razorthink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebGraphView : UIView
@property (nonatomic, strong) NSArray *namesArray;

-(id)initWithFrame:(CGRect)frame withDictionaryValues:(NSDictionary *)valuesDictionary withMaxValue:(CGFloat)maxValue ;
@end
