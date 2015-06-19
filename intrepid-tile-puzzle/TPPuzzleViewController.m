//
//  TPViewController.m
//  intrepid-tile-puzzle
//
//  Created by Maya Saxena on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TPPuzzleViewController.h"


static const CGFloat TileSlideAnimationTime = 0.25;

@interface TPPuzzleViewController ()
@property (strong, nonatomic) NSMutableArray *tiles;
@property (weak, nonatomic) UIButton *emptyTile;
@property (weak, nonatomic) IBOutlet UIView *puzzleView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property BOOL isSolved;
@property BOOL isPlaying;
@property float tileSpacing;
@property float tileStartCenter;
@property long tileCount;

@end

@implementation TPPuzzleViewController


- (instancetype)initWithSize:(NSInteger)size
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.size = size;
        self.isSolved = NO;
        self.tileSpacing = 300 / size;
        self.tileStartCenter = self.tileSpacing / 2;
        self.tileCount = size * size;
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.tiles = [[NSMutableArray alloc]init];
    
    int currentIndex = 0;
    for (int y = 2; y <= 300; y+= self.tileSpacing) {
        for (int x = 2; x <= 300; x+= self.tileSpacing) {
            UIButton *newTile = [UIButton buttonWithType:UIButtonTypeCustom];
            newTile.frame = CGRectMake(x, y, self.tileSpacing - 4, self.tileSpacing - 4);
            newTile.backgroundColor = [UIColor whiteColor];
            newTile.layer.cornerRadius = 10;
            [newTile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
            newTile.tag = currentIndex + 1;
            [newTile setTitle:[NSString stringWithFormat:@"%ld", (long)newTile.tag] forState:UIControlStateNormal];
            [newTile setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [newTile setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [newTile setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            newTile.enabled = NO;
            [self.puzzleView addSubview:newTile];
            [self.tiles addObject:newTile];
            currentIndex++;
        }
    }
    
    self.emptyTile = [self.tiles lastObject];
    self.emptyTile.hidden = NO;
    self.isPlaying = NO;
    
    
    [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [self shuffleTapped:nil];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionTransitionNone animations:^{
                self.statusLabel.text = @"Set...";
                self.emptyTile.alpha = 0;
        } completion:^(BOOL finished) {
            self.statusLabel.text = @"GO!";
            self.emptyTile.hidden = YES;
            self.emptyTile.alpha = 1;
            for (UIButton *tile in self.tiles) {
                tile.enabled = YES;
            }
        }];
    }];
    
}

- (void)viewDidLayoutSubviews {
    [self shuffleTapped:nil];
}

- (IBAction)tileTapped:(UIButton *)sender {
    self.isPlaying = YES;
    if (!self.isSolved) {
        CGRect newFrame = [self getAdjacentEmptyLocationForTile:sender];
        if (!CGRectIsNull(newFrame)) {
            [UIView animateWithDuration:TileSlideAnimationTime animations:^{
                self.emptyTile.frame = sender.frame;
                sender.frame = newFrame;
            } completion:^(BOOL finished) {
                if ([self puzzleSolved]) {
                    self.emptyTile.hidden = NO;
                    self.isSolved = YES;
                    self.isPlaying = NO;
                    [self alertPuzzleSolved];
                }
            }];
        }
    }
    
}

- (IBAction)resetTapped:(UIButton *)sender {
    int currentTileIndex = 0;
    for (int y = self.tileStartCenter; y <= 300; y+= self.tileSpacing) {
        for (int x = self.tileStartCenter; x <= 300; x+= self.tileSpacing) {
            ((UIButton *)self.tiles[currentTileIndex]).center = CGPointMake(x, y);
            currentTileIndex++;
        }
    }
    self.emptyTile.hidden = YES;
    
    
}

- (IBAction)shuffleTapped:(UIButton *)sender {
    long currentTileIndex = self.tileCount - 1;
    for (int y = self.tileStartCenter; y <= 300; y+= self.tileSpacing) {
        for (int x = self.tileStartCenter; x <= 300; x+= self.tileSpacing) {
            ((UIButton *)self.tiles[currentTileIndex]).center = CGPointMake(x, y);
            currentTileIndex--;
        }
    }
    self.isSolved = NO;
    if (self.isPlaying) {
        self.emptyTile.hidden = YES;
    }
    
}


#pragma mark - Alert Functions

- (void) alertPuzzleSolved {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You solved the puzzle!" message:@"Would you like to play again?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Play Again"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.isPlaying = YES;
                                                              [self shuffleTapped:nil];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:NO completion:nil];
}


#pragma mark - Tile Manipulation Functions

- (CGRect)getAdjacentEmptyLocationForTile:(UIButton *)tile {
    if (CGRectContainsPoint(self.emptyTile.frame, [self pointNorthOfTile:tile]) ||
        CGRectContainsPoint(self.emptyTile.frame, [self pointSouthOfTile:tile]) ||
        CGRectContainsPoint(self.emptyTile.frame, [self pointEastOfTile:tile]) ||
        CGRectContainsPoint(self.emptyTile.frame, [self pointWestOfTile:tile])) {
        return self.emptyTile.frame;
    } else {
        
        return CGRectNull;
    }
    
}

- (CGPoint) pointNorthOfTile:(UIButton *)tile {
    return CGPointMake(tile.center.x, tile.center.y - CGRectGetHeight(tile.frame));
}

- (CGPoint) pointSouthOfTile:(UIButton *)tile {
    return CGPointMake(tile.center.x, tile.center.y + CGRectGetHeight(tile.frame));
}

- (CGPoint) pointEastOfTile:(UIButton *)tile {
    return CGPointMake(tile.center.x + CGRectGetWidth(tile.frame), tile.center.y);
}

- (CGPoint) pointWestOfTile:(UIButton *)tile {
    return CGPointMake(tile.center.x - CGRectGetWidth(tile.frame), tile.center.y);
}

- (BOOL) puzzleSolved {
    int nextNumber = 1;
    for (int y = self.tileStartCenter; y <= 300; y+= self.tileSpacing) {
        for (int x = self.tileStartCenter; x <= 300; x+= self.tileSpacing) {
            for (UIButton *tile in self.tiles) {
                if (CGPointEqualToPoint(CGPointMake(x, y), tile.center)) {
                    if (tile.tag != nextNumber) {
                        return NO;
                    }
                    nextNumber++;
                }
            }
        }
    }
    return YES;
}


@end
