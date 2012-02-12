//
//  WebViewController.h
//  stackio
//
//  Created by Pete Hawkins on 12/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

// Properties to be synthesized
@property (nonatomic, strong) NSString *webUrlToVisit;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

// Actions
- (IBAction)backButton:(id)sender;
- (IBAction)forwardButton:(id)sender;
- (IBAction)reloadButton:(id)sender;

@end
