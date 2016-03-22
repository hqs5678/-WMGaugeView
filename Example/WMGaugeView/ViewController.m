//
//  ViewController.m
//  WMGaugeView
//
//  Created by William Markezana on 28/01/14.
//  Copyright (c) 2014 Will™. All rights reserved.
//

#import "ViewController.h"
#import "WMGaugeView.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface ViewController ()

@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;
@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _gaugeView.style = [WMGaugeViewStyle3D new];
    _gaugeView.maxValue = 100;
    _gaugeView.scaleDivisions = 10;
    _gaugeView.showRangeLabels = YES;
    _gaugeView.rangeValues = @[ @20,                  @40,                @80,               @100.0              ];
    _gaugeView.rangeColors = @[ RGB(232, 111, 33),    RGB(232, 231, 33),  RGB(27, 202, 33),   RGB(231, 32, 43)    ];
    _gaugeView.rangeLabels = @[ @"VERY LOW",          @"LOW",             @"OK",              @"OVER FILL"        ];
//    _gaugeView.unitOfMeasurement = @"健康度";
//    _gaugeView.showUnitOfMeasurement = YES;
    _gaugeView.scaleDivisionsWidth = 0.008;
    _gaugeView.scaleSubdivisionsWidth = 0.004;
    _gaugeView.rangeLabelsFontColor = [UIColor blueColor];
    _gaugeView.rangeLabelsWidth = 0.04;
    _gaugeView.rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.04];
    _gaugeView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    
    _gaugeView2.style = [WMGaugeViewStyleFlatThin new];
    _gaugeView2.maxValue = 100.0;
    _gaugeView2.scaleDivisions = 10;
    _gaugeView2.scaleSubdivisions = 5;
    _gaugeView2.scaleStartAngle = 80;
    _gaugeView2.scaleEndAngle = 280;
    
    _gaugeView2.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.035];
    _gaugeView2.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    _gaugeView2.scaleSubdivisionsWidth = 0.002;
    _gaugeView2.scaleSubdivisionsLength = 0.04;
    _gaugeView2.scaleDivisionsWidth = 0.007;
    _gaugeView2.scaleDivisionsLength = 0.07;
    _gaugeView2.showInnerBackground = NO;
    _gaugeView2.rangeValues = @[ @40,@80, @100.0];
    _gaugeView2.rangeColors = @[ RGB(232, 111, 33),RGB(27, 202, 33),RGB(231, 32, 43)];
    _gaugeView2.rangeLabels = @[@"LOW",@"OK", @"OVER FILL"];
   
    _gaugeView2.needleColor = [UIColor colorWithRed:0.163 green:0.205 blue:1.000 alpha:1.000];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(gaugeUpdateTimer:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)gaugeUpdateTimer:(NSTimer *)timer
{
    _gaugeView.value = rand()%(int)_gaugeView.maxValue;
    [_gaugeView2 setValue:rand()%(int)_gaugeView2.maxValue animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView2 animation complete");
    }];
}

@end
