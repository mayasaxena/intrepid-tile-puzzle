//
//  TPMainViewController.m
//  intrepid-tile-puzzle
//
//  Created by Maya Saxena on 6/19/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TPMainViewController.h"
#import "TPPuzzleViewController.h"

@interface TPMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) TPPuzzleViewController *puzzleViewController;
@property (strong, nonatomic) NSArray *puzzleImages;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (strong, nonatomic) UIImage *chosenImage;
@end

@implementation TPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Puzzle Game";
    self.puzzleImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"nebula.jpg"],
                                                  [UIImage imageNamed:@"panda.jpg"],
                                                  [UIImage imageNamed:@"snowleopard.jpg"],
                                                  [UIImage imageNamed:@"tiger.jpg"],
                                                  [UIImage imageNamed:@"flower.jpg"],
                                                  [UIImage imageNamed:@"yosemite.jpg"], nil];
    self.imagesCollectionView.backgroundColor = [UIColor whiteColor];
    UINib *cellNib = [UINib nibWithNibName:@"PuzzleImageCell" bundle:nil];
    [self.imagesCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PuzzleImageCell"];
}


- (IBAction)tappedPuzzleSize:(UIButton *)sender {
    [self choosePuzzleWithSize:sender.tag];
}

- (void) choosePuzzleWithSize:(long) size {
    self.puzzleViewController = [[TPPuzzleViewController alloc] initWithSize:size andImage:self.chosenImage];
    [self.navigationController pushViewController:self.puzzleViewController animated:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.puzzleImages count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PuzzleImageCell" forIndexPath:indexPath];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:self.puzzleImages[indexPath.row]];
    cell.backgroundView = backgroundView;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.chosenImage = self.puzzleImages[indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundView.alpha = .7;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.chosenImage = nil;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundView.layer.borderWidth = 0;
    cell.backgroundView.alpha = 1;
}

@end
