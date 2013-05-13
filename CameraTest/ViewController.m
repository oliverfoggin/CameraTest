//
//  ViewController.m
//  CameraTest
//
//  Created by Oliver Foggin on 05/13/13.
//  Copyright (c) 2013 Oliver Foggin. All rights reserved.
//

#import "ViewController.h"
#import "CameraManager.h"
#import "CameraCell.h"

static NSString *CameraCellReuseIdentifier = @"CameraCellReuseIdentifier";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) CameraManager *cameraManager;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.cameraManager = [[CameraManager alloc] init];

    self.view.backgroundColor = [UIColor whiteColor];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:recognizer];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setItemSize:CGSizeMake(280, 240)];
    [flowLayout setMinimumInteritemSpacing:50];
    [flowLayout setMinimumLineSpacing:50];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 20, 0, 20)];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CameraCell class] forCellWithReuseIdentifier:CameraCellReuseIdentifier];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.collectionView];

    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.cameraManager startRunning];
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    float width = self.view.frame.size.height;
    float height = self.view.frame.size.width;

    CGPoint focusPoint = CGPointMake(1 - point.x / width, 1 - point.y / height);

    [self.cameraManager focusAtPoint:focusPoint];
}

#pragma mark - collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CameraCellReuseIdentifier forIndexPath:indexPath];

    return cell;
}

@end