//
//  SearchPage.m
//  stackio
//
//  Created by Pete Hawkins on 11/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "SearchPage.h"
#import "StackTableViewController.h"
#import "URLEncoder.h"
#import "WebViewController.h"

@implementation SearchPage

@synthesize searchFormLabel = _searchFormLabel;
@synthesize searchQuery = _searchQuery;
@synthesize apiResults = _apiResults;

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

- (void)viewDidLoad
{
    // Set self as the delegate for text box
    self.searchQuery.delegate = self;
    
    // Set navigation bar to use an image
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navbar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Set text fields border style
    [self.searchQuery setBorderStyle:UITextBorderStyleRoundedRect];
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

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    self.apiResults = [json valueForKey:@"items"];
    
    if (self.apiResults.count > 0)
    {
        // Segue
        [self performSegueWithIdentifier:@"goResultsView" sender:self];
    }
    else
    {
        // No results matched the query
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No results found" 
                                                          message:@"Pro Tip: Try making your search less specific" 
                                                         delegate:nil
                                                cancelButtonTitle:@"Thanks!"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goResultsView"])
    {
        // It's the right segue lets pass the search query text
        StackTableViewController *newController = segue.destinationViewController;
        
        // Pass the API results to table view
        [newController setQuestions:[self apiResults]];
        
        // Set page title
        newController.title = self.searchQuery.text;
    }
    
    if ([segue.identifier isEqualToString:@"visitPhawk"])
    {
        // It's the right segue lets pass the search query text
        WebViewController *newController = segue.destinationViewController;
        
        // Lets set the pages title to be more relevant
        newController.title = @"phawk";
        
        newController.webUrlToVisit = @"http://phawk.co.uk";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // Once the user has entered their query, do the API call and segue
    [self getQuestionsTable];
    
    return YES;
}

/*
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
*/

- (void)getQuestionsTable
{
    // Check the textbox is not empty
    if (self.searchQuery.text.length > 0)
    {
        // Get our search query
        NSString *searchQueryText = [URLEncoder urlEncodeString:[self.searchQuery text]];
        
        // Build up our url
        NSURL *endpoint = [NSURL URLWithString: [@"http://api.stackexchange.com/2.0/search?order=desc&sort=activity&site=stackoverflow&intitle=" stringByAppendingString: searchQueryText]];
        
        // Create a new dispatch queue
        dispatch_queue_t apiCallQueue = dispatch_queue_create("getQuestions", NULL);
        
        // Do an async call to get the results
        dispatch_async(apiCallQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: endpoint];
            
            // Only if the data returns something usable
            if (data != nil)
            {
                [self performSelectorOnMainThread:@selector(fetchedData:) 
                                       withObject:data waitUntilDone:YES];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // We need to popup an alert to tell the user the interwebs are b0rked
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nightmare." 
                                                                      message:@"There seems to have been a problem with the interwebs" 
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Aww, Okay." 
                                                            otherButtonTitles:nil];
                    [message show];
                });
            }
        });
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

@end
