//
//  CalcViewController.m
//  IOS Calculator
//
//  Created by Gerald Blake on 9/27/13.
//  Copyright (c) 2013 Gerald Blake. All rights reserved.
//

#import "CalcViewController.h"

@interface CalcViewController ()
// accumulator methods
@property (strong, nonatomic) IBOutlet UITextField *infixTextField;
@property (strong, nonatomic) IBOutlet UIButton *clear;

-(void) handleParenthesis;
-(void)displayAnswer;
-(NSString*) process:(NSString*) infix;
-(void) hasOperator:(char) theOperator with:(int) thePrecedence;
-(double) evaluatePostfix:(NSString*) input;

@end

@implementation CalcViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.myTextField.delegate = self;
    self.accumulator = 0.0;
    self.numberValues=0.0;
    self.input=@"";
    self.output=@"";
    self.stack = [[NSMutableArray alloc] init];
    self.ADD_SUB_PRECEDENCE  = 1;
    self.MULT_DIV_PRECEDENCE = 2;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)negPos:(UIButton *)sender {
    double negPos = [self.infixTextField.text doubleValue];
    negPos *= (-1);
    self.infixTextField.text =[NSString stringWithFormat:@"%.11g",negPos];
    }

- (IBAction)buttonPressed:(UIButton *)sender
{
   
    self.infixTextField.text =[self.infixTextField.text stringByAppendingString:sender.titleLabel.text];
 
}
- (IBAction)Clear:(UIButton *)sender
{
    self.accumulator=0.0;
    self.infixTextField.text=@"";
    self.output=@"";
    self.stack = [[NSMutableArray array] init];
}

-(NSString*) process:(NSString*) infix
{
    int length, decimalPointCount = 0;
    
    // create the stack for translation of Infix to Postfix
    self.stack = [[NSMutableArray alloc]init];
    
    self.input = infix;
    
    length = (int)self.input.length;
    
    
    
    for (int i = 0; i < length; i++)
    {
        //
        // Process 1 character at a time
        // (spaces not necessary between operators)
        //
        char ch = [self.input characterAtIndex:i];
        if (isspace(ch))
            continue;
        switch (ch)
        {
			case '+':  // set precedence for + or -
			case '-':
                self.output =[self.output stringByAppendingString:@" "];
				decimalPointCount = 0; // reset count upon finding an operator
				[self hasOperator:ch with:self.ADD_SUB_PRECEDENCE];
				break;
                
			case '*': // set precedence for * or /
			case '/':
				self.output =[self.output stringByAppendingString:@" "];
				decimalPointCount = 0; // reset count upon finding an operator
				[self hasOperator:ch with:self.MULT_DIV_PRECEDENCE];
				break;
                
			case '(': // it's a left parenthesis push it onto the stack
                [self.stack addObject:[NSString stringWithFormat:@"%c",ch]];
				
				decimalPointCount = 0; // reset count upon finding an operator
				break;
                
			case ')': // it's a right parenthesis pop operators
				self.output =[self.output stringByAppendingString:@" "];	decimalPointCount = 0; // reset count upon finding an operator
				[self handleParenthesis];
				break;
                
			default: // if not any operator we handle must be a number
				// test to make sure.  If not don't add a valid character
				// exit.
				if (ch == '.')
					decimalPointCount++;
                
				if (decimalPointCount > 1)
				{
                            [self Clear:self.clear];
				}
                
				if (isdigit(ch) || ch == '.')
				{
					self.output =[self.output stringByAppendingString: [NSString stringWithFormat:@"%c",ch]]; // write ch to output
				}
				else
				{
					
				}
				break;
        }
    }
    // after last number (operand print a space)
    self.output =[self.output stringByAppendingString:@" "];
    
    // pop operators from the stack
    while ([self.stack count]!=0)
    {
        self.output =[self.output stringByAppendingString:[self.stack lastObject]];
        [self.stack removeLastObject];
        self.output =[self.output stringByAppendingString:@" "];
    }
    
    return self.output; // return postfix string
} // end of process method

-(void) hasOperator:(char) theOperator with:(int) thePrecedence
{
    while ([self.stack count]!=0)
    {
        char topOperator = [[self.stack lastObject]characterAtIndex:0];
         [self.stack removeLastObject];
        if (topOperator == '(')
        {
            [self.stack addObject:[NSString stringWithFormat:@"%c",topOperator]];
        
            break;
        }
        else
        {
            //
            // determine the precedence of the stack's top operator:
            // +,- -> level ADD_SUB_PRECEDENCE  (1)
            // *,/ -> level MULT_DIV_PRECEDNECE (2)
            //
            int topOperatorPrecedence = 0;
            if (topOperator == '+' || topOperator == '-')
            {
                topOperatorPrecedence = 1;
            }
            else if (topOperator == '*' || topOperator == '/')
            {
                topOperatorPrecedence = 2;
            }
            
            // if precedence of new operator less
            // than precedence of old operator
            if (topOperatorPrecedence < thePrecedence)
            {
                // save newly-popped operator
                [self.stack addObject:[NSString stringWithFormat:@"%c",topOperator]];
                break;
            } 
            else{
                // precedence of new operator is not less
                // than precedence of old
                // add space after operator for readable format
                self.output =[self.output stringByAppendingString:[NSString stringWithFormat:@"%c",topOperator]];
                [self.stack removeLastObject];
                self.output =[self.output stringByAppendingString:@" "];
            }
        }
    }
    
   [self.stack addObject:[NSString stringWithFormat:@"%c",theOperator]];
} // end of gotOperator method

/**
 * gotParenthesis
 *
 */
-(void) handleParenthesis
{
    while ([self.stack count] !=0)
    {
        char stackChar  = [[self.stack lastObject]characterAtIndex:0];
        [self.stack removeLastObject];

      
        if (stackChar == '(')
            break;
        else{
            // pop operators from stack till left parenthesis
            // add space after stackChar for readability of output string
            self.output=[self.output stringByAppendingString:[NSString stringWithFormat:@"%c",stackChar]];
        }
    }
    
} // end of gotParenthesis method


- (IBAction)Equal:(UIButton *)sender
{
    [self displayAnswer];
}
-(void)displayAnswer
{
    self.output = [self process: self.infixTextField.text];
    // evaluate postfix string
    self.accumulator += [self evaluatePostfix:self.output];
    self.infixTextField.text =[NSString stringWithFormat:@"%.11g",self.accumulator];
    self.output=@"";
    self.accumulator=0.0;
}
-(double) evaluatePostfix:(NSString*) input
{
    double number1 = 0.0;
    double number2 = 0.0;
    double answer  = 0.0;
    double result  = 0.0;
    NSString *s = @"";
    char op;
    NSMutableArray *theStack = [[NSMutableArray alloc] init];

    NSArray *tokens = [input componentsSeparatedByString:@" "];
    
    for (NSString *token in tokens)
    {
        // if token is not an operator it's an operand to push onto the stack
        if (![@"+" isEqual:token] && ![@"*"isEqual:token] &&
            ![@"-" isEqual:token] && ![@"/"isEqual:token])
        {
            [theStack addObject:token];
        }
        else
        {
          
            self.value = [theStack lastObject];
            number2 = [self.value doubleValue];
            [theStack removeLastObject];
            
            self.value = [theStack lastObject];
            number1 = [self.value doubleValue];
            [theStack removeLastObject];
            
            op = [token characterAtIndex:0];
            
                switch(op)
                {
					case '+':
						result = number1 + number2;
						s = [NSString stringWithFormat:@"%.11g",result];
                        [theStack addObject: s];
						break;
                        
					case '-':
						result = number1 - number2;
						s = [NSString stringWithFormat:@"%.11g",result];
                        [theStack addObject: s];
						break;
                        
					case '*':
						result = number1 * number2;
						s = [NSString stringWithFormat:@"%.11g",result];
                        [theStack addObject: s];
                        break;
                        
					case '/':
						if (number2 == 0.0)
						{
							
                            [self Clear:self.clear];
                            self.infixTextField.text=@"Error: Division by 0";
							return 1;
						}else{
						result = number1 / number2;
						s = [NSString stringWithFormat:@"%.11g",result];
                        [theStack addObject: s];
                        }
						break;
                }
           // }
        }
    }
    // the answer should be the last element on the stack
   [theStack removeLastObject];
    answer = [[theStack lastObject] doubleValue];
    return answer;
    
} // end of evaluatePostfix method
- (IBAction)infixTextFieldResigner:(UITextField *)sender {
    [self displayAnswer];
    [sender resignFirstResponder];
}


@end
