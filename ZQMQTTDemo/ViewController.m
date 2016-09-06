//
//  ViewController.m
//  ZQMQTTDemo
//
//  Created by Zhou Qian on 16/9/4.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import "ViewController.h"
#import <MQTTClient.h>
#import <MQTTSessionManager.h>
#import <ZQTableViewKit/ZQTableViewKit.h>

@interface ViewController () <MQTTSessionManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MQTTSessionManager *manager;
@property (nonatomic, strong) NSDictionary *mqttSettings;

@property (nonatomic, strong) NSMutableArray *arrChat;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *topic;

//UI
//@property (nonatomic, strong) ZQTableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *tfInput;

@end

@implementation ViewController

- (void)dealloc {
    [self.manager removeObserver:self forKeyPath:@"state"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.manager.state == MQTTSessionManagerStateClosed) {
        [self.manager connectToLast];
    }
    [self.manager addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
}
- (void)initUI {
//    self.tableView = [[ZQTableView alloc] init];
//    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
}
#pragma mark - Action

- (void)connect {
    [self.manager connectToLast];
}
- (void)disconnect {
    [self sendMessage:@"goodbye"];
    [self.manager disconnect];
}
- (void)sendMessage:(NSString *)message {
    [self.manager sendData:[message dataUsingEncoding:NSUTF8StringEncoding]
                     topic:self.topic
                       qos:MQTTQosLevelExactlyOnce
                    retain:NO];
}
- (IBAction)sendAction:(id)sender {
    [self sendMessage:self.tfInput.text];
}

#pragma mark - MQTTSessionManagerDelegate

- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self.arrChat addObject:[NSString stringWithFormat:@"%@-%@", topic, msg]];
    //reload data
    [self.tableView reloadData];
}

#pragma mark - Setter and Getter

- (MQTTSessionManager *)manager {
    if (!_manager) {
        NSString *keyBase = [NSString stringWithFormat:@"%@/#", self.mqttSettings[@"base"]];
        _manager = [[MQTTSessionManager alloc] init];
        _manager.delegate = self;
        _manager.subscriptions = @{keyBase : @(MQTTQosLevelExactlyOnce)};
        [_manager connectTo:self.mqttSettings[@"host"]
                       port:[self.mqttSettings[@"port"] integerValue]
                        tls:[self.mqttSettings[@"tls"] boolValue]
                  keepalive:60
                      clean:YES
                       auth:NO
                       user:nil
                       pass:nil
                  willTopic:self.topic
                       will:[@"offline" dataUsingEncoding:NSUTF8StringEncoding]
                    willQos:MQTTQosLevelExactlyOnce
             willRetainFlag:NO
               withClientId:nil];
    }
    return _manager;
}
- (NSDictionary *)mqttSettings {
    if (!_mqttSettings) {
        NSURL *mqttPlistUrl = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"mqtt.plist"];
        _mqttSettings = [NSDictionary dictionaryWithContentsOfURL:mqttPlistUrl];
    }
    return _mqttSettings;
}
- (NSMutableArray *)arrChat {
    if (!_arrChat) {
        _arrChat = [[NSMutableArray alloc] init];
    }
    return _arrChat;
}
- (NSString *)topic {
    if (!_topic) {
        _topic = [NSString stringWithFormat:@"%@/%@", self.mqttSettings[@"base"],[UIDevice currentDevice].name];
    }
    return _topic;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrChat.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.arrChat[indexPath.row];
    return cell;
}
@end
