//
//  ViewController.m
//  Film District
//
//  Created by jose1009 on 6/23/21.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testingLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.testingLabel.text = @"hola";
}


@end
