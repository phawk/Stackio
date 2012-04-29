//
//  StackTableViewController.m
//  stackio
//
//  Created by Pete Hawkins on 12/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "StackTableViewController.h"
#import "WebViewController.h"

@implementation StackTableViewController
@synthesize resultsTable = _resultsTable;
@synthesize searchString = _searchString;
@synthesize searchModel = _searchModel;
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

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setResultsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Bind a wee observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionCameBackWithData:) name:@"questionDataReturned" object:nil];
    
    // Instantiate question model
    self.goToQuestion = [[QuestionModel alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Remove the observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"questionDataReturned" object:nil];
}

- (NSDictionary *)getDataForRowAtIndex:(NSInteger)rowNumber
{
    QuestionModel *question = [self.searchModel getQuestionAtRow:rowNumber];
    return question.question;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. We have 1 sections in this table
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchModel countQuestions];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"resultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *question = [self getDataForRowAtIndex:indexPath.row];
    
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
    NSDictionary *question = [self getDataForRowAtIndex:indexPath.row];
    
    NSNumber *id = [question objectForKey:@"question_id"];
    
    NSLog(@"Question selected %@", id);
    
    // Ask question model to go get a new question
    [self.goToQuestion getQuestion:[id stringValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openQuestionViewController"])
    {
        // Get the URL to visit from the cell (sender)
        
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

- (void)questionCameBackWithData:(NSNotification *) notification
{
    // Hide network indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([self.goToQuestion populated])
    {
        [self performSegueWithIdentifier:@"openQuestionViewController" sender:self.goToQuestion];
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
