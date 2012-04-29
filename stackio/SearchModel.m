//
//  SearchModel.m
//  stackio
//
//  Created by Pete Hawkins on 28/04/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "SearchModel.h"
#import "URLEncoder.h"
#import "QuestionModel.h"

@implementation SearchModel

- (void)getQuestionsFromAPI:(NSString *)withQuery
{
    // Check the textbox is not empty
    if (withQuery.length > 0)
    {
        // Get our search query
        NSString *searchQueryText = [URLEncoder urlEncodeString:withQuery];
        
        // Build up our url
        NSURL *endpoint = [NSURL URLWithString: [@"http://api.stackexchange.com/2.0/search?order=desc&sort=activity&key=51eAx6uDTUtYJHLxjD8oww((&site=stackoverflow&intitle=" stringByAppendingString: searchQueryText]];
        
        // Create a new dispatch queue
        dispatch_queue_t apiCallQueue = dispatch_queue_create("getQuestions", NULL);
        
        // Do an async call to get the results
        dispatch_async(apiCallQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: endpoint];
            
            // Only if the data returns something usable
            if (data != nil)
            {
                [self returnedData:data];
            }
            else
            {
                [self fireNotification];
            }
        });
        
        // Release the download queue to stop leaks
        dispatch_release(apiCallQueue);
    }
}

- (void)returnedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray *apiResults = [json valueForKey:@"items"];
    
    // Setup questions to be an NSArray
    questions = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in apiResults)
    {
        // Create a question model and push it onto the questions array
        [questions addObject:[[QuestionModel alloc] initWithData:dict]];
    }

    // Fire notification that results are in
    [self fireNotification];
}

- (NSArray *)getQuestions
{
    return questions;
}

- (QuestionModel *)getQuestionAtRow:(int)row
{
    QuestionModel *question = [questions objectAtIndex:row];
    return question;
}

- (int)countQuestions
{
    int count = [questions count];
    return count;
}

- (BOOL)hasResults
{
    BOOL hasQuestios = [self countQuestions] > 0 ? YES : NO;
    return hasQuestios;
}

- (void)fireNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchDataReturned" object:nil];
    });
}

@end
