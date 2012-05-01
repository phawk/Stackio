//
//  MyQuestionsTableViewController.m
//  stackio
//
//  Created by Pete Hawkins on 16/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "MyQuestionsTableViewController.h"
#import "WebViewController.h"

@implementation MyQuestionsTableViewController

@synthesize myQuestions = _myQuestions;
@synthesize tableView = _tableView;
@synthesize goToQuestion = _goToQuestion;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set navigation bar to use an image
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navbar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Get users ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [defaults objectForKey:@"userData"];
    NSNumber *userId = [user objectForKey:@"user_id"];
    
    // Get questions from API
    [self getUsersQuestionsWithID:userId];
    
    // Instantiate question model
    self.goToQuestion = [[QuestionModel alloc] init];
    
    // Bind a wee observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionCameBackWithData:) name:@"questionDataReturned" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove the observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"questionDataReturned" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyQuestionTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *question = [self.myQuestions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [question objectForKey:@"title"];
    cell.detailTextLabel.text = [question objectForKey:@"link"];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Show network indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *question = [self.myQuestions objectAtIndex:indexPath.row];
    
    NSNumber *id = [question objectForKey:@"question_id"];
    
    NSLog(@"Question selected %@", id);
    
    // Ask question model to go get a new question
    [self.goToQuestion getQuestion:[id stringValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openMyQuestionViewController"])
    {
        // It's the right segue lets pass the search query text
        ActualQuestionTableViewController *newController = segue.destinationViewController;
        
        newController.hidesBottomBarWhenPushed = YES;
        
        NSDictionary *qDict = self.goToQuestion.question;
        
        NSLog(@"DICT: %@", qDict);
        
        // Lets set the pages title to be more relevant
        newController.title = [qDict objectForKey:@"title"];
        
        newController.question = self.goToQuestion;
    }
}





- (void)getUsersQuestionsWithID:(NSNumber *)usersId
{
    // Check the access token is there
    if (usersId)
    {
        // Show activity indicator and network indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // Build up our url
        NSURL *endpoint = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.stackexchange.com/2.0/users/%@/questions?site=stackoverflow&key=51eAx6uDTUtYJHLxjD8oww((", usersId]];
        
        // Create a new dispatch queue
        dispatch_queue_t getUsersQuestions = dispatch_queue_create("getUsersQuestions", NULL);
        
        // Do an async call to get the results
        dispatch_async(getUsersQuestions, ^{
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
                    
                    // FAILED
                    NSLog(@"%@", @"Failed for data coming back");
                });
            }
        });
        
        // Release the download queue to stop leaks
        dispatch_release(getUsersQuestions);
    }
    else
    {
        // FAILED
        NSLog(@"%@", @"Failed for users ID being nil");
    }
}

- (void)fetchedData:(NSData *)responseData
{
    // Hide activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    NSLog(@"got data: %@", json);
    self.myQuestions = [json valueForKey:@"items"];
    
    // Success, reload the table view
    [self.tableView reloadData];
}

- (void)questionCameBackWithData:(NSNotification *) notification
{
    // Hide network indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([self.goToQuestion populated])
    {
        [self performSegueWithIdentifier:@"openMyQuestionViewController" sender:self.goToQuestion];
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nightmare." 
                                                          message:@"We couldn't load your question." 
                                                         delegate:nil
                                                cancelButtonTitle:@":/ Okay.."
                                                otherButtonTitles:nil];
        [message show];
    }
}

@end
