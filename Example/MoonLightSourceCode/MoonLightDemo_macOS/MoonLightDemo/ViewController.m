//
//  ViewController.m
//  MoonLightDemo
//
//  Created by LJJ on 2020/11/12.
//

#import "ViewController.h"
#import "MoonLight.h"
#import "MLANRDetectPing.h"
#import "MLSuspendingView.h"

@interface ViewController() <MoonLightDelegate, MLANRDetectDelegate>
@property (nonatomic, strong) MoonLight *moonLight;
@property (weak) IBOutlet NSTextField *system_cpu1;
@property (nonatomic, assign) BOOL isStart;
@property (weak) IBOutlet NSButton *stopAndStartTimer;
@property (weak) IBOutlet NSTextField *gpuUsage;
@property (weak) IBOutlet NSTextField *appCPU;
@property (weak) IBOutlet NSTextField *appMemory;
@property (weak) IBOutlet NSTextField *gpuInfo;
@property (weak) IBOutlet NSTextField *anrCount;
@property (nonatomic, strong) MLANRDetectPing *detectPing;
@property (nonatomic, strong) MLSuspendingView *suspendingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _suspendingView = [[MLSuspendingView alloc] init];
    _isStart = true;
    _moonLight = [[MoonLight alloc] initWithDelegate:self timeInterval:1];
    [_moonLight startTimer];
    _detectPing = [MLANRDetectPing initWithMonitoringQueue:dispatch_get_main_queue()];
    _detectPing.delegate = self;
    [_detectPing start];
    [self.view addSubview:_suspendingView.infoLabel];
    
    // Test ANR
    [NSThread sleepForTimeInterval:4];
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
    NSLog(@"systemCPU:%f", systemCPU);
    NSLog(@"gpuInfo:%@", gpuInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.system_cpu1.stringValue = [NSString stringWithFormat:@"system_cpu:%f",systemCPU];
        self.gpuUsage.stringValue = [NSString stringWithFormat:@"gpuUsage:%f",gpuUsage];
        self.appCPU.stringValue = [NSString stringWithFormat:@"appCPU:%f",appCPU];
        self.appMemory.stringValue = [NSString stringWithFormat:@"appMemory:%f",appMemory];
        self.gpuInfo.stringValue = [NSString stringWithFormat:@"gpuInfo: %@",gpuInfo];
        NSInteger sum = self.moonLight.cpuAnrCount + self.detectPing.count + self.moonLight.gpuAnrCount;
        self.anrCount.stringValue = [NSString stringWithFormat:@"ANRCount: %ld",sum];
        self.suspendingView.infoLabel.stringValue = [NSString stringWithFormat:@"SysCPU:%.2f\n AppCPU:%.2f\n AppMem:%.2f\n GPU:%.2f\n ANRCount:%ld",systemCPU,appCPU,appMemory,gpuUsage, (long)sum];
    });
}

- (void)anrOutputStackFromPing:(NSString *)stack anrSum:(NSInteger)anrSum {
    NSLog(@"基于线程卡顿检测出发生了ANR，当前的堆栈地址是：%@，ANR发生的总次数是：%ld",stack,(long)anrSum);
}

- (void)captureOutputCpuAnr:(NSString *)symbols cpuAnrSum:(NSInteger)cpuAnrSum{
    NSLog(@"通过CPU检测出当前发生了ANR，当前的堆栈地址是：%@，ANR发生的总次数是：%ld",symbols,(long)cpuAnrSum);
}
- (void)captureOutputGpuAnr:(NSString *)symbols gpuAnrSum:(NSInteger)gpuAnrSum {
    NSLog(@"通过GPU检测出当前发生了ANR，当前的堆栈地址是：%@，ANR发生的总次数是：%ld",symbols, (long)gpuAnrSum);
}
@end
