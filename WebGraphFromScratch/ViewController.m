//
//  ViewController.m
//  WebGraphFromScratch
//
//  Created by Kumaraswamy on 02/03/16.
//  Copyright © 2016 Razorthink. All rights reserved.
//

#import "ViewController.h"
#import "WebGraphView.h"
#import "WebGraphDataSource.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *valueDictionary = nil;
    
    valueDictionary =   @{@"Core": @"4",
                          @"Upperarm": @"2",
                          @"chest" : @"4.5",
                          @"Forearm": @"4",
                          @"Shoulder" : @"5",
                          @"Back" : @"3",
                      
                                      };
    
    NSArray *sectorNamesArry = [[NSArray alloc]initWithObjects:@"Core",@"Upperarm",@"chest",@"Forearm",@"Shoulder",@"Back", nil];
    NSArray *sectorValueArray = [[NSArray alloc]initWithObjects:@"4",@"2",@"",@"4.5",@"4",@"5" ,@"3",nil];
    NSMutableArray *webGraphDataSourceArry = [[NSMutableArray alloc]init];
    for (int i=0; i<valueDictionary.count; i++) {
        WebGraphDataSource *webGraphDataSource = [[WebGraphDataSource alloc]init];
        webGraphDataSource.sectorName =  [sectorNamesArry objectAtIndex:i];
        webGraphDataSource.sectorValue = [sectorValueArray objectAtIndex:i];
        [ webGraphDataSourceArry addObject:webGraphDataSource];
        
    }
    
    WebGraphView *webGraphView = [[WebGraphView alloc]initWithFrame:self.view.frame withDictionaryValues:valueDictionary withMaxValue:6];
    self.view = webGraphView;
   }
    @end
