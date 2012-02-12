//
//  SearchPage.m
//  stackio
//
//  Created by Pete Hawkins on 11/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "SearchPage.h"
#import "StackTableViewController.h"

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
    // Get our search query
    NSString *searchQueryText = self.searchQuery.text;
    
    // Build up our url
    NSURL *endpoint = [NSURL URLWithString: [@"http://api.stackexchange.com/2.0/search?order=desc&sort=activity&site=stackoverflow&intitle=" stringByAppendingString: searchQueryText]];
    
    // Do an async call to get the results
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: endpoint];
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    });
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
}
@end
