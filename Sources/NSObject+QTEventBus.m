//
//  NSObject+QTEventBus.m
//  QTEventBus
//
//  Created by Leo on 2018/6/1.
//  Copyright © 2018年 Leo Huang. All rights reserved.
//

#import "NSObject+QTEventBus.h"
#import "QTEventBus.h"
#import <objc/runtime.h>
#import "QTAppEvent.h"

static const char event_bus_disposeContext;

@implementation NSObject (QTEventBus)

- (QTDisposeBag *)eb_disposeBag{
    QTDisposeBag * bag = objc_getAssociatedObject(self, &event_bus_disposeContext);
    if (!bag) {
        bag = [[QTDisposeBag alloc] init];
        objc_setAssociatedObject(self, &event_bus_disposeContext, bag, OBJC_ASSOCIATION_RETAIN);
    }
    return bag;
}

- (QTEventSubscriberMaker *)subscribe:(Class)eventClass{
    return [QTEventBus shared].on(eventClass).freeWith(self);
}

- (QTEventSubscriberMaker *)subscribe:(Class)eventClass on:(QTEventBus *)bus{
    return bus.on(eventClass).freeWith(self);
}

@end


@implementation NSObject(EventBus_JSON)

- (QTEventSubscriberMaker *)subscribeJSON:(NSString *)name{
    return [QTEventBus shared].on(QTJsonEvent.class).freeWith(self).ofType(name);
}

@end

@implementation NSObject(EventBus_Notification)
/**
 监听通知
 */
- (QTEventSubscriberMaker<NSNotification *> *)subscribeNotification:(NSString *)name{
    return [QTEventBus shared].on(NSNotification.class).freeWith(self);
}

- (QTEventSubscriberMaker *)subscribeAppDidBecomeActive{
    return [self subscribeNotification:QTAppEvent.didBecomeActive];
}

- (QTEventSubscriberMaker *)subscribeAppDidEnterBackground{
    return [self subscribeNotification:QTAppEvent.didEnterBackground];
}

- (QTEventSubscriberMaker *)subscribeAppDidFinishLaunching{
    return [self subscribeNotification:QTAppEvent.didFinishLaunching];
}

- (QTEventSubscriberMaker *)subscribeAppDidReceiveMemoryWarning{
    return [self subscribeNotification:QTAppEvent.didReceiveMemoryWarning];
}

- (QTEventSubscriberMaker *)subscribeUserDidTakeScreenshot{
    return [self subscribeNotification:QTAppEvent.userDidTakeScreenshot];
}

- (QTEventSubscriberMaker *)subscribeAppWillEnterForground{
    return [self subscribeNotification:QTAppEvent.willEnterForground];
}

- (QTEventSubscriberMaker *)subscribeAppWillResignActive{
    return [self subscribeNotification:QTAppEvent.willResignActive];
}

- (QTEventSubscriberMaker *)subscribeAppWillTerminate{
    return [self subscribeNotification:QTAppEvent.willTerminate];
}

@end