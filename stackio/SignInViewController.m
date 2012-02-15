//
//  SignInViewController.m
//  stackio
//
//  Created by Pete Hawkins on 15/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "SignInViewController.h"

@implementation SignInViewController
@synthesize webView = _webView;

NSString * const oauthClientId = @"112";
NSString * const oauthClientSecret = @"h)NWO*vXZGQca50PNr)SWA((";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkIfLoginRequired];
}

- (void)checkIfLoginRequired
{
    [self oauthLogin];
}

- (void)oauthLogin
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://stackexchange.com/oauth/dialog?client_id=112&redirect_uri=https://stackexchange.com/oauth/login_success"]];
    [self.webView loadRequest:req];
}



- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Web View Events
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *urlString = self.webView.request.URL.absoluteString;
    [self checkForAccessToken:urlString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><style>body{ color: #e7e7e7; background: #121212; font-family: Helvetica, sans-serif; text-align: center; } h1{ color: #b9000e; font-size: 32px; margin: 30px auto; } .error{ margin:20px; padding:20px; background: #333; border: 1px solid #000; }</style></head><body><div class=\"error\"><h1>oh dear!</h1> <p>%@</p></div></body></html>",
							 error.localizedDescription];
	[self.webView loadHTMLString:errorString baseURL:nil];
}

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    
    [self checkForAccessToken:urlString];
    
    return TRUE;
}
*/

- (IBAction)backButton:(id)sender
{
    [self.webView goBack];
}

- (IBAction)forwardButton:(id)sender
{
    [self.webView goForward];
}

- (IBAction)reloadButton:(id)sender
{
    [self.webView reload];
}

- (void)checkForAccessToken:(NSString *)urlString {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern:@"access_token=(.*)&" 
                                  options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = 
        [regex firstMatchInString:urlString 
                          options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken 
                           stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self accessTokenFound:accessToken];               
        }
    }
}

- (void)accessTokenFound:(NSString *)accessToken
{
    NSLog(@"Your access token is: %@", accessToken);
    
    // We need to store the access token, then move forward into the application
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"accessToken"];
    [defaults synchronize];
    
    // We then can then load up the main view
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    UITabBarController *tabBar = [mainStoryBoard instantiateViewControllerWithIdentifier:@"mainTabBar"];
    
    // Push the loaded up view to the screen
    [self presentViewController:tabBar animated:YES completion:^{}];
}

@end
