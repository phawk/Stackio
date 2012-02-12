//
//  WebViewController.m
//  stackio
//
//  Created by Pete Hawkins on 12/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webUrlToVisit = _webUrlToVisit;
@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set ourselves as a delegate of the web view
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Lets tell our web view to load the url we set
    NSString *urlToVisit = self.webUrlToVisit;
    
    // Lets tell the web view to go to url
    NSURL *url = [NSURL URLWithString:urlToVisit]; 
    NSURLRequest *req = [NSURLRequest requestWithURL:url]; 
    
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

#pragma Web View Toolbar buttons
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

@end
