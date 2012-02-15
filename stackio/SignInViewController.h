//
//  SignInViewController.h
//  stackio
//
//  Created by Pete Hawkins on 15/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)backButton:(id)sender;
- (IBAction)forwardButton:(id)sender;
- (IBAction)reloadButton:(id)sender;

- (void)checkForAccessToken:(NSString *)urlString;
- (void)checkIfLoginRequired;
- (void)oauthLogin;
- (void)accessTokenFound:(NSString *)accessToken;

@end
