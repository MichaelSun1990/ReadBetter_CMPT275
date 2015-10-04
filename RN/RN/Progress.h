//
//  Progress.h
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.

//  Programmers who have worked on it: Yang Shi
//
//  What we have done so far: Just interface and force autorotate

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface Progress : UIViewController

<CPTBarPlotDataSource, CPTBarPlotDelegate>
@property (nonatomic) int progressCount;
@property (nonatomic, strong) NSString* totalWord;
@property (nonatomic, strong) NSString* totalTime;
@property(nonatomic,retain) NSMutableArray *words;
@property (weak, nonatomic) IBOutlet UILabel *wordsTotal;
@property (weak, nonatomic) IBOutlet UILabel *timeTotal;
@property (weak, nonatomic) IBOutlet UIImageView *graphcontain;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) CPTXYGraph *graph;




@end
