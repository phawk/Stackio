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
@synthesize welcomeLabel = _welcomeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set navigation bar to use an image
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navbar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userData = [defaults objectForKey:@"userData"];
    
    // Welcome the user
    NSString *user = [self.userData objectForKey:@"display_name"];
    
    // Set welcome text
    if (user != nil) { self.welcomeLabel.text = [@"Welcome " stringByAppendingString:user]; }
}


- (void)viewDidUnload
{
    [self setWelcomeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logoutButton:(id)sender
{
    // Remove saved data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userData"];
    [defaults removeObjectForKey:@"accessToken"];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *loginView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"loginScreen"];
    
    // Push the loaded up view to the screen
    [self presentViewController:loginView animated:YES completion:^{}];
}
@end
