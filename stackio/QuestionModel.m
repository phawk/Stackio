//
//  QuestionModel.m
//  stackio
//
//  Created by Pete Hawkins on 28/04/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "QuestionModel.h"
#import "URLEncoder.h"

@implementation QuestionModel

@synthesize question = _question;

- (id) initWithData:(NSDictionary *)data
{
    if(self = [super init])
    {
        self.question = data;
    }
    return self;
}

- (void)getQuestion:(NSString *)withID
{
    hasData = NO;
    
    // Build a url and do an async request to the API
    // Check the textbox is not empty
    if (withID.length > 0)
    {
        // Get our search query
        NSString *questionID = [URLEncoder urlEncodeString:withID];
        NSString *urlString = [@"http://api.stackexchange.com/2.0/questions/" stringByAppendingString:questionID];
        NSString *params = @"?order=desc&sort=activity&site=stackoverflow&filter=!-)dQBkwABs32";
        NSString *fullUrl = [urlString stringByAppendingString:params];
        
        NSLog(@"Calling url: %@", fullUrl);
        
        // Build up our url
        NSURL *endpoint = [NSURL URLWithString: fullUrl];
        
        // Create a new dispatch queue
        dispatch_queue_t apiCallQuestionQueue = dispatch_queue_create("getQuestion", NULL);
        
        // Do an async call to get the results
        dispatch_async(apiCallQuestionQueue, ^{
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
        dispatch_release(apiCallQuestionQueue);
    }
}

- (void)returnedData:(NSData *)responseData
{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray *apiResults = [json valueForKey:@"items"];
    
    // Setup questions to be an NSArray
    self.question = [apiResults objectAtIndex:0];
    
    NSLog(@"API Question received: %@", self.question);
    
    hasData = YES;
    
    // Fire notification that results are in
    [self fireNotification];
}

- (BOOL)populated
{
    return hasData;
}

- (void)fireNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"questionDataReturned" object:nil];
    });
}

- (int)getAnswerCount
{
    NSArray *answers = [self.question objectForKey:@"answers"];
    return [answers count];
}

- (NSDictionary *)getDataWithIndex:(NSIndexPath *)indexPath
{
    NSDictionary *data;
    if (indexPath.section == 0)
    {
        // Return the question
        data = self.question;
    }
    else {
        NSArray *answers = [self.question objectForKey:@"answers"];
        data = [answers objectAtIndex:indexPath.row];
    }
    
    return data;
}

@end
