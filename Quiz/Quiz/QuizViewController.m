//
//  QuizViewController.m
//  Quiz
//
//  Created by Leo Gau on 3/5/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()
// Private variable
@property int currentQuestionIndex;

// The model objects
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *answers;

// The view objects
@property (weak, nonatomic) IBOutlet UILabel *questionField;
@property (weak, nonatomic) IBOutlet UILabel *answerField;

@end

@implementation QuizViewController

#pragma mark - view controller lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create two arrays and make the pointers point to them
        self.questions = [[NSMutableArray alloc] init];
        self.answers = [[NSMutableArray alloc] init];
        
        // Add questions and answers to the arrays
        [self.questions addObject:@"What is 7 + 7?"];
        [self.answers addObject:@"14"];
        
        [self.questions addObject:@"What is the capital of Vermont?"];
        [self.answers addObject:@"Montpelier"];
        
        [self.questions addObject:@"From what is congnac made?"];
        [self.answers addObject:@"Grapes"];
    }
    
    // Return the address of the new object
    return self;
}


- (IBAction)showQuestion:(UIButton *)sender
{
    // Step to the next question
    self.currentQuestionIndex += 1;
    
    // Am I past the last question?
    if (self.currentQuestionIndex == [self.questions count]) {
        // Go back to the first question
        self.currentQuestionIndex = 0;
    }
    
    // Get the string at the index in the questions array
    NSString *question = self.questions[self.currentQuestionIndex];
    [self.questionField setText:question];
    
    // Clear the answer field
    [self.answerField setText:@"???"];
}

- (IBAction)showAnswer:(UIButton *)sender
{
    // What is the answer to the current question?
    NSString *answer = self.answers[self.currentQuestionIndex];
    [self.answerField setText:answer];
}


@end
