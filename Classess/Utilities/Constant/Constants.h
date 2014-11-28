//
//  Constants.h
//  CardWiser
//
//  Created by Andy Boariu on 27/03/14.
//  Copyright (c) ProtovateLLC. All rights reserved.
//

// ******** API Keys**********************************
#define API_KEY_LINKEDIN              @"75vm02yj08bx27";
#define API_SECRETKEY_LINKEDIN        @"I7phOkuoVtGok0r1";

#define isIpad                      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define isIphone                    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define isIphone_5                   ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define appDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define deviceWidth ([[UIScreen mainScreen] bounds].size.width)
#define deviceHeight ([[UIScreen mainScreen] bounds].size.height)

//*>    Define macros for color
#define App_Theme_Color                [UIColor colorWithRed:19/255.0 green:143/255.0 blue:210/255.0 alpha:1.0]
#define White_Color                    [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]