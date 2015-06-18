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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tiles;
@property (weak, nonatomic) IBOutlet UIButton *emptyTile;


@property BOOL isSolved;
@property float tileSpacing;
@property float tileStartCenter;
@property float tileCount;

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
    
    
    for (UIButton *tile in self.tiles) {
        tile.layer.cornerRadius = 10;
    }
    
    [UIView animateWithDuration:TileSlideAnimationTime delay:3.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [self shuffleTapped:nil];
    } completion:nil];
    
}

- (void)viewDidLayoutSubviews {
    [self shuffleTapped:nil];
}

- (IBAction)tileTapped:(UIButton *)sender {
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
                    [self alertPuzzleSolved];
                }
            }];
        }
    }
    
}

- (IBAction)resetTapped:(UIButton *)sender {
    
    //    [UIView animateWithDuration:1.0 animations:^{
    int currentTileIndex = 0;
    for (int y = self.tileStartCenter; y <= 300; y+= self.tileSpacing) {
        for (int x = self.tileStartCenter; x <= 300; x+= self.tileSpacing) {
            ((UIButton *)self.tiles[currentTileIndex]).center = CGPointMake(x, y);
            currentTileIndex++;
        }
    }
    self.emptyTile.hidden = YES;
    
    //    }];
    
    
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
    self.emptyTile.hidden = YES;
    
}


#pragma mark - Alert Functions

- (void) alertPuzzleSolved {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You solved the puzzle!" message:@"Would you like to play again?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Play Again"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
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
