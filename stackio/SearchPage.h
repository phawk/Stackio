//
//  SearchPage.h
//  stackio
//
//  Created by Pete Hawkins on 11/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@interface SearchPage : UIViewController <UITextFieldDelegate>

// Properties to synthesize
@property (weak, nonatomic) IBOutlet UITextField *searchQuery;
@property (weak, nonatomic) IBOutlet UILabel *searchFormLabel;
@property (strong, nonatomic) NSArray *apiResults;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) SearchModel *searchModel;

// Methods to implement
- (void)getQuestionsTable;
- (void)searchCameBackWithResults:(NSNotification *) notification;
- (IBAction)tappedAway:(id)sender;

@end
