//
//  QuestionModel.h
//  stackio
//
//  Created by Pete Hawkins on 28/04/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
{
    BOOL hasData;
}

@property (strong, nonatomic) NSDictionary *question;

- (id) initWithData:(NSDictionary *)data;

- (void)getQuestion:(NSString *)withID;
- (void)fireNotification;
- (void)returnedData:(NSData *)responseData;
- (BOOL)populated;

@end
