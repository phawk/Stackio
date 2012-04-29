//
//  SearchPage.m
//  stackio
//
//  Created by Pete Hawkins on 11/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "SearchPage.h"
#import "StackTableViewController.h"
#import "WebViewController.h"

@implementation SearchPage

@synthesize searchFormLabel = _searchFormLabel;
@synthesize searchQuery = _searchQuery;
@synthesize apiResults = _apiResults;
@synthesize activityIndicator = _activityIndicator;
@synthesize searchModel = _searchModel;

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
    
    // Set self as the delegate for text box
    self.searchQuery.delegate = self;
    
    // Set navigation bar to use an image
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navbar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Set text fields border style
    [self.searchQuery setBorderStyle:UITextBorderStyleRoundedRect];
    
    // Setup activity indicator to be used on page
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.activityIndicator.center = self.view.center;
//    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview: self.activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Open the keyboard on view appearing.
    // [self.searchQuery becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchCameBackWithResults:) name:@"searchDataReturned" object:nil];
    
    // Load up the search model
    self.searchModel = [[SearchModel alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Remove the observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchDataReturned" object:nil];
}

- (void)viewDidUnload
{
    [self setSearchQuery:nil];
    [self setSearchFormLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goResultsView"])
    {
        // It's the right segue lets pass the search query text
        StackTableViewController *newController = segue.destinationViewController;
        
        // Pass the API results to table view
        newController.searchModel = self.searchModel;
        
        // Set page title
        newController.title = self.searchQuery.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // Once the user has entered their query, do the API call and segue
    [self getQuestionsTable];
    
    return YES;
}

- (void)getQuestionsTable
{
    if (self.searchQuery.text.length > 0)
    {
        // Show activity indicator and network indicator
        [self.activityIndicator startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *searchQuery = self.searchQuery.text;
        
        // Get the search model to go off and get stuff
        [self.searchModel getQuestionsFromAPI:searchQuery];
    }
    else
    {
        // We need to popup an alert to inform the user to enter a search query
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nightmare." 
                                                          message:@"You need to tell me what to search for!" 
                                                         delegate:nil
                                                cancelButtonTitle:@"Alright, Gosh!" 
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)searchCameBackWithResults:(NSNotification *) notification
{
    BOOL resultsExist = [self.searchModel hasResults];
    if (resultsExist)
    {
        [self performSegueWithIdentifier:@"goResultsView" sender:self];
    }
    else
    {
        // We need to popup an alert to tell the user the interwebs are b0rked
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nightmare." 
                                                          message:@"There seems to have been a problem with the interwebs" 
                                                         delegate:nil
                                                cancelButtonTitle:@"Aww, Okay." 
                                                otherButtonTitles:nil];
        [message show];
    }
    
    // Hide activity indicators
    [self.activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)tappedAway:(id)sender
{
    // User has tapped to dismiss keyboard
    [self.searchQuery resignFirstResponder];
}

@end
