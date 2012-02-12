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

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define StackExchangeSearchEndpoint [NSURL URLWithString: @"http://api.stackexchange.com/2.0/search?order=desc&sort=activity&intitle=php&site=stackoverflow"]

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
    self.searchQuery.delegate = self;
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

- (IBAction)searchButton:(id)sender {
    
    if (self.searchQuery.text.length > 0)
    {
        // Get our search query
        NSString *searchQueryText = [URLEncoder urlEncodeString:[self.searchQuery text]];
        
        // Build up our url
        NSURL *endpoint = [NSURL URLWithString: [@"http://api.stackexchange.com/2.0/search?order=desc&sort=activity&site=stackoverflow&intitle=" stringByAppendingString: searchQueryText]];
        
        // Do an async call to get the results
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: endpoint];
            [self performSelectorOnMainThread:@selector(fetchedData:) 
                                   withObject:data waitUntilDone:YES];
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

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    self.apiResults = [json valueForKey:@"items"];
    
    // Log the data that comes back
    NSLog(@"Total: %d", [self.apiResults count]);
    
    // Segue
    [self performSegueWithIdentifier:@"goResultsView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goResultsView"])
    {
        // It's the right segue lets pass the search query text
        StackTableViewController *newController = segue.destinationViewController;
        
        [newController setQuestions:[self apiResults]];
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
    
    return YES;
}

@end
