//
//  Progress.m
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "Progress.h"


@interface Progress ()

@end

@implementation Progress 

#define BAR_POSITION @"POSITION"
#define BAR_HEIGHT @"HEIGHT"
#define COLOR @"COLOR"
#define CATEGORY @"CATEGORY"

#define AXIS_START 0
#define AXIS_YEND 20
#define AXIS_XEND 50

@synthesize data;
@synthesize graph;
@synthesize hostingView;
@synthesize totalTime,totalWord,wordsTotal,timeTotal,progressCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)generateBarPlot
{
    //Create host view
    CGRect viewRect = CGRectMake(0,30,320,350);
    self.hostingView = [[CPTGraphHostingView alloc]
                        initWithFrame:viewRect];
    [self.view addSubview:self.hostingView];
    
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.hostingView.bounds];
    [self.hostingView setHostedGraph:self.graph];
    
    //set graph padding and theme
    self.graph.plotAreaFrame.paddingTop = 20.0f;
    self.graph.plotAreaFrame.paddingRight = 40.0f;
    self.graph.plotAreaFrame.paddingBottom = 70.0f;
    self.graph.plotAreaFrame.paddingLeft = 70.0f;
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    
    //set axes ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(AXIS_START)
                                                    length:CPTDecimalFromFloat((AXIS_XEND - AXIS_START))];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(AXIS_START)
                                                    length:CPTDecimalFromFloat((AXIS_YEND - AXIS_START))];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    //set axes' title, labels and their text styles
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 14;
    textStyle.color = [CPTColor whiteColor];
    axisSet.xAxis.title = @"Progress check sequence(0,1,2...)";
    axisSet.yAxis.title = @"WordCount(per 1000)";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = 10.0f;
    axisSet.yAxis.titleOffset = 40.0f;
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 3.0f;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.yAxis.labelOffset = 3.0f;
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 3.0f;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(10.0f);
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(2.0f);
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTicksPerInterval = 0;
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.minorTickLength = 0.0f;
    axisSet.yAxis.minorTickLength = 5.0f;
    
    // Create bar plot and add it to the graph
    CPTBarPlot *plot = [[CPTBarPlot alloc] init] ;
    plot.dataSource = self;
    plot.delegate = self;
    plot.barWidth = [[NSDecimalNumber decimalNumberWithString:@"5.0"]
                     decimalValue];
    plot.barOffset = [[NSDecimalNumber decimalNumberWithString:@"5.0"]
                      decimalValue];
    plot.barCornerRadius = 2.0;
    // Remove bar outlines
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor clearColor];
    plot.lineStyle = borderLineStyle;
    // Identifiers are handy if you want multiple plots in one graph
    plot.identifier = @"reading";
    [self.graph addPlot:plot];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot.identifier isEqual:@"reading"] )
        return [self.data count];
    
    return 0;
}
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ( [plot.identifier isEqual:@"reading"] )
    {
        NSDictionary *bar = [self.data objectAtIndex:index];
        
        if(fieldEnum == CPTBarPlotFieldBarLocation)
            return [bar valueForKey:BAR_POSITION];
        else if(fieldEnum ==CPTBarPlotFieldBarTip)
            return [bar valueForKey:BAR_HEIGHT];
    }
    return [NSNumber numberWithFloat:0];
}
-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    if ( [plot.identifier isEqual: @"reading"] )
    {
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.fontName = @"Helvetica";
        textStyle.fontSize = 14;
        textStyle.color = [CPTColor whiteColor];
        
        NSDictionary *bar = [self.data objectAtIndex:index];
        CPTTextLayer *label =[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@", [bar valueForKey:@"CATEGORY"]]] ;
        label.textStyle =textStyle;
        
        return label;
    }
    
    CPTTextLayer *defaultLabel = [[CPTTextLayer alloc] initWithText:@"Label"];
    return defaultLabel;
    
}
-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index
{
    if ( [barPlot.identifier isEqual:@"reading"] )
    {
        NSDictionary *bar = [self.data objectAtIndex:index];
        CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor whiteColor]
                                                            endingColor:[bar valueForKey:@"COLOR"]
                                                      beginningPosition:0.0 endingPosition:0.3 ];
        [gradient setGradientType:CPTGradientTypeAxial];
        [gradient setAngle:320.0];
        
        CPTFill *fill = [CPTFill fillWithGradient:gradient];
        
        return fill;
        
    }
    return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
}

-(void) graphPaint{
    NSString *temp =[[NSUserDefaults standardUserDefaults]stringForKey:@"progress"];
    progressCount = [temp intValue];
    [_words addObject: wordsTotal.text];
    self.data = [NSMutableArray array];
    float bar_heights[100];
    NSString *categories[100];
    categories[progressCount] = wordsTotal.text;
    
    for (int i = 0; i <= progressCount; i++){
        bar_heights[i] = [wordsTotal.text intValue]/1000.0f;
    };
    
    UIColor *colors[] = {
        [UIColor blueColor],
    };
    categories[progressCount] = wordsTotal.text;
    
    for (int i = 0; i <= progressCount; i++){
        double position = i*5; //Bars will be 10 pts away from each other
        double height = bar_heights[i];
        //double height= [wordsTotal.text intValue]/1000.0f;
        NSDictionary *bar = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithDouble:position],BAR_POSITION,
                             [NSNumber numberWithDouble:height],BAR_HEIGHT,
                             colors[0],COLOR,
                             categories[i],CATEGORY,
                             nil];
        [self.data addObject:bar];
        
    }
    [self generateBarPlot];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //load the total word and total time
    totalWord =[[NSUserDefaults standardUserDefaults]stringForKey:@"WordCount"];
    totalTime =[[NSUserDefaults standardUserDefaults]stringForKey:@"Time"];
    float transtime = [totalTime intValue]/3600.00; //transfer the time from second to hour
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"]; // the formatter
    wordsTotal.text = totalWord;
    timeTotal.text = [fmt stringFromNumber:[NSNumber numberWithFloat:transtime]];
    // Do any additional setup after loading the view.
    progressCount = 0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger: progressCount] forKey:@"progress"];
    [self graphPaint];
    progressCount++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger: progressCount] forKey:@"progress"];


    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Force the view to rotate if needed
- (BOOL)shouldAutorotate{
    return YES;
}

//The orientation should be portrait
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
