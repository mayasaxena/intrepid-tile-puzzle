//
//  TPViewController.m
//  intrepid-tile-puzzle
//
//  Created by Maya Saxena on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TPViewController.h"

@interface TPViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tiles;
@property (weak, nonatomic) IBOutlet UIButton *emptyTile;

@end

@implementation TPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *tile in self.tiles) {
        tile.layer.cornerRadius = 10;
    }
}

- (IBAction)tileTapped:(UIButton *)sender {
    CGRect newLocation = [self getAdjacentEmptyLocationForTile:sender];
    if (!CGRectIsNull(newLocation)) {
        [UIView animateWithDuration:0.5f animations:^{
            [self.emptyTile setFrame:sender.frame];
            [sender setFrame:newLocation];
        } completion:^(BOOL finished) {
            if ([self puzzleSolved]) {
                self.emptyTile.hidden = NO;
            }
        }];
    }
    
}

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
    return CGPointMake(tile.center.x, tile.center.y - tile.frame.size.height);
}

- (CGPoint) pointSouthOfTile:(UIButton *)tile {
    return CGPointMake(tile.center.x, tile.center.y + tile.frame.size.height);
}

- (CGPoint) pointEastOfTile:(UIButton *)tile {
    return CGPointMake(tile.center.x + tile.frame.size.width, tile.center.y);
}

- (CGPoint) pointWestOfTile:(UIButton *)tile {
    return CGPointMake(tile.center.x - tile.frame.size.width, tile.center.y);
}

- (BOOL) puzzleSolved {
    int nextNumber = 1;
    for (int y = 50; y <= 250; y+= 100) {
        for (int x = 50; x <= 250; x+= 100) {
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
