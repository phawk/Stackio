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
@synthesize questions = _questions;

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
    
    // Log the model: NSLog(@"Questions: %@", self.questions);
}

- (NSDictionary *)getDataForRowAtIndex:(NSInteger)rowNumber
{
    NSDictionary *question = [self.questions objectAtIndex:rowNumber];
    return question;
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
    return [self.questions count];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"openWebView" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openWebView"])
    {
        // Get the URL to visit from the cell (sender)
        UITableViewCell *cell = sender;
        NSString *url = cell.detailTextLabel.text;
        
        // It's the right segue lets pass the search query text
        WebViewController *newController = segue.destinationViewController;
        
        newController.hidesBottomBarWhenPushed = YES;
        
        // Lets set the pages title to be more relevant
        newController.title = cell.textLabel.text;
        
        newController.webUrlToVisit = url;
    }
}

@end
