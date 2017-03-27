//
//  GALLoginViewController.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 3..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#ifndef Langtudy_GALLoginViewController_h
#define Langtudy_GALLoginViewController_h

#import "CommonInputViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface GALLoginViewController : CommonInputViewController <GIDSignInDelegate,GIDSignInUIDelegate>


@end

#endif
