//
//  IupAppDelegateProtocol.h
//  iup
//
//  Created by Eric Wing on 12/22/16.
//  Copyright © 2016 Tecgraf, PUC-Rio, Brazil. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IupAppDelegateProtocol <UIApplicationDelegate>
- (UIWindow*) currentWindow;
@end
