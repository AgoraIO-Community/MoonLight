//
//  ViewController.m
//  MoonLightDemo_iOS
//
//  Created by LJJ on 2020/11/13.
//

#import "ViewController.h"
#import "MoonLight.h"
#import "MLSuspendingView.h"
#import "MLANRDetectPing.h"

@interface ViewController() <MoonLightDelegate, MLANRDetectDelegate>
@property (nonatomic, strong) MoonLight *moonLight;
@property (nonatomic, assign) BOOL isStart;
@property (weak, nonatomic) IBOutlet UIButton *stopAndStartTimer;
@property (weak, nonatomic) IBOutlet UILabel *system_cpu1;
@property (weak, nonatomic) IBOutlet UILabel *app_cpu;
@property (weak, nonatomic) IBOutlet UILabel *app_memory;
@property (weak, nonatomic) IBOutlet UILabel *gpu;
@property (weak, nonatomic) IBOutlet UILabel *fps;
@property (nonatomic, strong) MLSuspendingView *suspendingView;
@property (nonatomic, strong) MLANRDetectPing *detectPing;
@property (weak, nonatomic) IBOutlet UIButton *createSuspendingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.suspendingView = [[MLSuspendingView alloc]init];
    _isStart = true;
    _moonLight = [[MoonLight alloc]initWithDelegate:self timeInterval:1];
    [_moonLight startTimer];
    _detectPing = [MLANRDetectPing initWithMonitoringQueue:dispatch_get_main_queue()];
    _detectPing.delegate = self;
    [_detectPing start];
    // Test ANR
    [NSThread sleepForTimeInterval:4];
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

- (IBAction)createAndRemove:(id)sender {
    if (_isStart) {
        [_moonLight stopTimer];
        _moonLight.delegate = nil;
        _moonLight = nil;
        [_detectPing stop];
        _detectPing = nil;
        [_suspendingView closeSuspendingView];
        _suspendingView = nil;
        [_createSuspendingView setTitle:@"createSuspendingView" forState:UIControlStateNormal];
    } else {
        self.suspendingView = [[MLSuspendingView alloc]init];
        _moonLight = [[MoonLight alloc]initWithDelegate:self timeInterval:1];
        [_moonLight startTimer];
        _detectPing = [MLANRDetectPing initWithMonitoringQueue:dispatch_get_main_queue()];
        [_detectPing start];
        [_createSuspendingView setTitle:@"removeSuspendingView" forState:UIControlStateNormal];
    }
    _isStart = !_isStart;
    
}

# pragma mark: -- Delegate
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
        self.fps.text = [NSString stringWithFormat:@"fps:%f",self.moonLight.fps];
        NSInteger sum = self.moonLight.cpuAnrCount + self.detectPing.count + self.moonLight.gpuAnrCount;
        self.suspendingView.infoLabel.text = [NSString stringWithFormat:@"SysCPU:%.2f\n AppCPU:%.2f\n AppMem:%.2f\n GPU:%.2f\n FPS:%.2f\n ANRCount:%ld",systemCPU,appCPU,appMemory,gpuUsage,self.moonLight.fps, (long)sum];
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
