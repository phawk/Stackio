//
//  SearchModel.h
//  stackio
//
//  Created by Pete Hawkins on 28/04/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"

@interface SearchModel : NSObject
{
    NSMutableArray *questions;
}

- (void)getQuestionsFromAPI:(NSString *)withQuery;
- (void)returnedData:(NSData *)responseData;
- (NSArray *)getQuestions;
- (QuestionModel *)getQuestionAtRow:(int)row;
- (int)countQuestions;
- (void)fireNotification;
- (BOOL)hasResults;

@end
