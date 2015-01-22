//
//  Stack.h
//  IOS Calculator
//
//  Created by Gerald Blake on 9/28/13.
//  Copyright (c) 2013 Gerald Blake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/Object.h>


@interface Stack : NSObject
{
    StackLink *top;
    unsigned int size;
}

- free;
- push: (int) anInt;
- (int) pop;
- (unsigned int) size;

@end
