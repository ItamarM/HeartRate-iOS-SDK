HeartRateKit
====================================

## Introduction

iOS SDK heart rate monitor which uses the camera and its flash to determine the users heart rate in beats per minute.
The kit has its own UI. Feel free to customize!

## Usage

    HeartRateKitController *controller = [[HeartRateKitController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];

Check the [sample project](PulseDetector) for demonstration.

## License
See the [LICENSE](https://github.com/ItamarM/HeartRate-iOS-SDK/blob/master/LICENSE) file (MIT).
