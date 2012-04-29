//
//  StackTableViewController.h
//  stackio
//
//  Created by Pete Hawkins on 12/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import "QuestionModel.h"
#import "ActualQuestionTableViewController.h"

@interface StackTableViewController : UITableViewController

// Properties to synthesize
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;
@property(nonatomic, strong) NSString *searchString;
@property(nonatomic, strong) SearchModel *searchModel;
@property(nonatomic, strong) QuestionModel *goToQuestion;

- (void)questionCameBackWithData:(NSNotification *) notification;

@end
