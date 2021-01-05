//
//  ViewController.m
//  MoonLightDemo_iOS
//
//  Created by LJJ on 2020/11/13.
//

#import "ViewController.h"
#import "MoonLight.h"

@interface ViewController() <MoonLightDelegate>
@property (nonatomic, strong) MoonLight *moonLight;
@property (nonatomic, assign) BOOL isStart;
@property (weak, nonatomic) IBOutlet UIButton *stopAndStartTimer;
@property (weak, nonatomic) IBOutlet UILabel *system_cpu1;
@property (weak, nonatomic) IBOutlet UILabel *app_cpu;
@property (weak, nonatomic) IBOutlet UILabel *app_memory;
@property (weak, nonatomic) IBOutlet UILabel *gpu;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isStart = true;
    _moonLight = [[MoonLight alloc]initWithDelegate:self timeInterval:1];
    [_moonLight startTimer];
}


- (IBAction)stopTimer:(id)sender {
    if (_isStart) {
        [_moonLight stopTimer];
        [_stopAndStartTimer setTitle:@"startTimer" forState:UIControlStateNormal];
    } else {
        [_moonLight startTimer];
        [_stopAndStartTimer setTitle:@"stopTimer" forState:UIControlStateNormal] ;
    }
    _isStart = !_isStart;
}



- (void)captureOutputAppCPU:(float)appCPU systemCPU:(float)systemCPU appMemory:(float)appMemory gpuUsage:(float)gpuUsage gpuInfo:(NSString *)gpuInfo {
    NSLog(@"appMemory:%f", appMemory);
    NSLog(@"appCPU:%f", appCPU);
    NSLog(@"gpuUsage:%f", gpuUsage);
    NSLog(@"systemCPU:%f", systemCPU);
    NSLog(@"gpuInfo:%@", gpuInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.system_cpu1.text = [NSString stringWithFormat:@"SystemCPU:%f",systemCPU];
        self.app_cpu.text = [NSString stringWithFormat:@"AppCPU:%f",appCPU];
        self.app_memory.text = [NSString stringWithFormat:@"AppMemory:%f",appMemory];
        self.gpu.text = [NSString stringWithFormat:@"GPU:%f",gpuUsage];
    });
}

@end
