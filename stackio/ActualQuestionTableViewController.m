//
//  ActualQuestionTableViewController.m
//  stackio
//
//  Created by Pete Hawkins on 28/04/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "ActualQuestionTableViewController.h"

@interface ActualQuestionTableViewController ()

@end

@implementation ActualQuestionTableViewController

@synthesize question;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // One section for the question, another for the answers
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return section == 2 ? [self.question getAnswerCount] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"webViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIWebView* webView = [[UIWebView alloc] initWithFrame:
                              CGRectMake(10, 10, cell.bounds.size.width - 20, cell.bounds.size.height - 20)];
        //webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        webView.tag = 1001;
        webView.userInteractionEnabled = NO;
        webView.backgroundColor = [UIColor blackColor];
        webView.opaque = NO;

        [cell addSubview:webView];
    }
    
    // Get the web view by tag
    UIWebView* webView = (UIWebView*)[cell viewWithTag:1001];
    webView.delegate = self;
    
    // Get data for the cell
    NSDictionary *data = [self.question getDataWithIndex:indexPath];
    
    // Get our htmls
    NSString *titleHtml = [data objectForKey:@"title"];
    if (titleHtml == nil) {
        titleHtml = @"[No Title]";
    }
    
    NSString *bodyHtml = [data objectForKey:@"body"];
    if (bodyHtml == nil) {
        bodyHtml = @"No content.";
    }
    
    // Build up our html string
    NSString *title = [NSString stringWithFormat:@"<h1>%@</h1>", titleHtml];
    NSString *body = [title stringByAppendingString:bodyHtml];
    NSString *html = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=\"web_styles.css\" /></head><body>%@</body></html>", body];
    
    // Tell our web view to load the string
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webView loadHTMLString:html baseURL:baseURL];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
