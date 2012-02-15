//
//  UserViewController.m
//  stackio
//
//  Created by Pete Hawkins on 15/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "UserViewController.h"

@implementation UserViewController

@synthesize userData = _userData;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *accessToken = [defaults objectForKey:@"accessToken"];
    
    // Get user data from API
    [self getUserDataWithAccessToken:accessToken];
}

- (void)getUserDataWithAccessToken:(NSString *)accessToken
{
    // Check the access token is there
    if (accessToken.length > 0)
    {
        // Show activity indicator and network indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // Build up our url
        NSURL *endpoint = [NSURL URLWithString: [@"https://api.stackexchange.com/2.0/me?site=stackoverflow&key=51eAx6uDTUtYJHLxjD8oww((&access_token=" stringByAppendingString: accessToken]];
        
        // Create a new dispatch queue
        dispatch_queue_t getUserData = dispatch_queue_create("getUserData", NULL);
        
        // Do an async call to get the results
        dispatch_async(getUserData, ^{
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
                    
                    // Hide activity indicator
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
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
        
        // Release the download queue to stop leaks
        dispatch_release(getUserData);
    }
    else
    {
        // Access token is empty, we need to go to root view to login.
    }
}

- (void)fetchedData:(NSData *)responseData {
    // Hide activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray *apiResult = [json valueForKey:@"items"];
    
    self.userData = [apiResult objectAtIndex:0];
    
    NSLog(@"got userdata: %@", self.userData);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
