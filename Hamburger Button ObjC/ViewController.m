//
//  ViewController.m
//  Hamburger Button ObjC
//
//  Created by James Whelton on 7/6/14.
//  Copyright (c) 2014 Whelton. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:(52/255.0) green:(152/255.0) blue:(219/255.0) alpha:1];
    
    _button = [[HamburgerButton alloc] initWithFrame:CGRectMake(133, 133, 54, 54)];
    [_button addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)toggle:(id)sender {
    _button.showsMenu = !_button.showsMenu;
}

@end
