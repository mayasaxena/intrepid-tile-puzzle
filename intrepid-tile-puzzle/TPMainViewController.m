//
//  TPMainViewController.m
//  intrepid-tile-puzzle
//
//  Created by Maya Saxena on 6/19/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TPMainViewController.h"
#import "TPPuzzleViewController.h"

@interface TPMainViewController ()

@property (strong, nonatomic) TPPuzzleViewController *puzzleViewController;

@end

@implementation TPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Puzzle Game";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) choosePuzzleWithSize:(long) size {
    self.puzzleViewController = [[TPPuzzleViewController alloc] initWithSize:size andImage:[UIImage imageNamed:@"nebula.jpg"]];
    [self.navigationController pushViewController:self.puzzleViewController animated:YES];
}


- (IBAction)tappedPuzzleSize:(UIButton *)sender {
    
    [self choosePuzzleWithSize:sender.tag];
}

@end
