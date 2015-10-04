//
//  BookTable.h
//  RN
//
//  Created by Sy on 13-11-9.
//  Copyright (c) 2013 16. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyReader.h"
@interface BookTable : UITableViewController
@property (nonatomic,strong) NSDictionary *book;
@property (nonatomic,strong) NSMutableArray *bookName;
@property (weak, nonatomic) IBOutlet UIButton *backbutton;

@property int index;
@end
