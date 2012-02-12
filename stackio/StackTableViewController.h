//
//  StackTableViewController.h
//  stackio
//
//  Created by Pete Hawkins on 12/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;

@property(nonatomic, strong) NSString *searchString;
@property(nonatomic, strong) NSArray *questions;

@end
