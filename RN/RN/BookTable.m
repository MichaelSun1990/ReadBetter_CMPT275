//
//  BookTable.m
//  RN
//
//  Created by Sy on 13-11-9.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "BookTable.h"
@interface BookTable ()

@end

@implementation BookTable
@synthesize book, bookName;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //if the segue is "bookRead" then give the value of the path of the file
    if ([segue.identifier  isEqual: @"bookRead"]){
        EasyReader *er = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSString *currentbook = [bookName objectAtIndex:path.row];
        er.path =  [NSString stringWithFormat:@"%@/group16.app/%@",NSHomeDirectory(),currentbook];
    }
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_backbutton titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:20];
    //look up the directory and find the txt files
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/group16.app/",NSHomeDirectory()] error:nil];
    bookName = [[NSMutableArray alloc] init];
    for (int count = 2; count < files.count; count++) {
        [bookName addObject:[files objectAtIndex:count]];
    }
    //set the filter
    NSString *match = @"txt";
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@ AND NOT SELF CONTAINS %@", match,@"words" ];
    [bookName setArray:[files filteredArrayUsingPredicate:sPredicate]];
}



-(void) viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [bookName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSString *currentBookName = [bookName objectAtIndex:indexPath.row];
    [[cell textLabel] setText:currentBookName];
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

#pragma mark - Table view delegate

//Force the view to rotate if needed
- (BOOL)shouldAutorotate{
    return YES;
}

//The orientation should be landscape
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
@end
//