//
//  ViewController.m
//  MoonLightDemo
//
//  Created by LJJ on 2020/11/12.
//

#import "ViewController.h"
#import "MoonLight.h"

@interface ViewController() <MoonLightDelegate>
@property (nonatomic, strong) MoonLight *moonLight;
@property (weak) IBOutlet NSTextField *system_cpu1;
@property (nonatomic, assign) BOOL isStart;
@property (weak) IBOutlet NSButton *stopAndStartTimer;
@property (weak) IBOutlet NSTextField *gpuUsage;
@property (weak) IBOutlet NSTextField *appCPU;
@property (weak) IBOutlet NSTextField *appMemory;
@property (weak) IBOutlet NSTextField *gpuInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isStart = true;
    _moonLight = [[MoonLight alloc] initWithDelegate:self timeInterval:1];
    [_moonLight startTimer];
}

- (IBAction)stopTimer:(id)sender {
    if (_isStart) {
        [_moonLight stopTimer];
        _stopAndStartTimer.title = @"startTimer";
    } else {
        [_moonLight startTimer];
        _stopAndStartTimer.title = @"stopTimer";
    }
    _isStart = !_isStart;
}

- (void)captureOutputAppCPU:(float)appCPU systemCPU:(float)systemCPU appMemory:(float)appMemory gpuUsage:(float)gpuUsage gpuInfo:(NSString *)gpuInfo {
    NSLog(@"gpuUsage:%f", gpuUsage);
    NSLog(@"appMemory:%f", appMemory);
    NSLog(@"appCPU:%f", appCPU);
    NSLog(@"gpuInfo:%@", gpuInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.system_cpu1.stringValue = [NSString stringWithFormat:@"system_cpu:%f",systemCPU];
        self.gpuUsage.stringValue = [NSString stringWithFormat:@"gpuUsage:%f",gpuUsage];
        self.appCPU.stringValue = [NSString stringWithFormat:@"appCPU:%f",appCPU];
        self.appMemory.stringValue = [NSString stringWithFormat:@"appMemory:%f",appMemory];
        self.gpuInfo.stringValue = [NSString stringWithFormat:@"gpuInfo: %@",gpuInfo];
    });
    
}



@end
