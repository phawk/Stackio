//
//  ActualQuestionTableViewController.h
//  stackio
//
//  Created by Pete Hawkins on 28/04/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface ActualQuestionTableViewController : UITableViewController

@property (strong, nonatomic) QuestionModel *question;

@end
