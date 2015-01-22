//
//  CalcViewController.h
//  IOS Calculator
//
//  Created by Gerald Blake on 9/27/13.
//  Copyright (c) 2013 Gerald Blake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalcViewController : UIViewController
@property (nonatomic) double accumulator;
@property (nonatomic) double numberValues;
@property (strong,nonatomic) NSString *theString;
@property (strong,nonatomic) NSString *input;
@property (strong,nonatomic) NSString *output;
@property (strong,nonatomic) NSMutableArray *stack;
@property(nonatomic) id value;
@property (nonatomic)int ADD_SUB_PRECEDENCE;
@property (nonatomic)int MULT_DIV_PRECEDENCE;

@end
