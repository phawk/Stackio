//
//  URLEncoder.m
//  stackio
//
//  Created by Pete Hawkins on 12/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import "URLEncoder.h"

@implementation URLEncoder

+ (NSString *)urlEncodeString:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

@end
