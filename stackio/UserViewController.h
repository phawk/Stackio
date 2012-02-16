//
//  UserViewController.h
//  stackio
//
//  Created by Pete Hawkins on 15/02/2012.
//  Copyright (c) 2012 phawk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController

@property (strong, nonatomic) NSDictionary *userData;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;

@end
