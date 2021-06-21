//
//  IupLaunchViewController.h
//  iup
//
//  Created by Eric Wing on 12/22/16.
//  Copyright © 2016 Tecgraf, PUC-Rio, Brazil. All rights reserved.
//

/**
This class is mostly a placeholder for launch time because
iOS must start an app with something on the screen,
but IUP's API isn't supposed to create anything until after the programmer says to.
*/

#import <UIKit/UIKit.h>
#include "iup.h"

@interface IupViewController : UIViewController
@property(nonatomic, assign) Ihandle* ihandle;
@end
