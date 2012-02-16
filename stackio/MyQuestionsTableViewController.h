//
//  MyQuestionsTableViewController.h
//  stackio
//
//  Created by Pete Hawkins on 16/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQuestionsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *myQuestions;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)getUsersQuestionsWithID:(NSNumber *)usersId;
- (void)fetchedData:(NSData *)responseData;

@end
