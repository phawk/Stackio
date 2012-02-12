//
//  SearchPage.h
//  stackio
//
//  Created by Pete Hawkins on 11/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPage : UIViewController <UITextFieldDelegate>

// Properties to synthesize
@property (weak, nonatomic) IBOutlet UITextField *searchQuery;
@property (weak, nonatomic) IBOutlet UILabel *searchFormLabel;
@property (strong, nonatomic) NSArray *apiResults;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

// Methods to implement
- (void)getQuestionsTable;
- (IBAction)tappedAway:(id)sender;

@end
