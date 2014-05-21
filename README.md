Multiton
========

[![Build Status](https://travis-ci.org/belkevich/multiton.png?branch=master)](https://travis-ci.org/belkevich/multiton)

Multiton is a better alternative to singleton. It's more flexible and require less code lines to implement. 

Features:
* Make shared instance of class just by including `ABMultitonProtocol` to class interface. No implementation needed!
* Remove shared instance of class when you don't need it anymore (unit-tests!). No more immortal instances!
* Specify is shared instance should be removed on memory warning. 
* Create shared instance with custom `init` method with arguments. 
* Set custom instance that will return as `shared`.

**Warning**
> This is not implementation of classic [multiton](http://en.wikipedia.org/wiki/Multiton_pattern). This implementation uses instance `class name` as `key` to access instance.

#### Installation

Add to [Podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile)
```
pod 'ABMultiton'
```

#### Using

##### 1. Shared instance
Class should conforms to `ABMultitonProtocol`

```objective-c
#import "ABMultitonProtocol.h"
...
@interface MyClass : ParentClass <ABMultitonProtocol>
...
@end
```
And that's all! `ABMultiton` will add `shared` method implementation in runtime. And you can access shared instance just like this:
```objective-c
[MyClass.shared myMethod];
```

##### 2. Shared instance with custom initilization
`ABMultiton` implements `shared` method in this way
```objective-c
return [[MyClass alloc] init];
```

And if you need to use some custom `init` method you should implement `shared` method by yourself in this way:
```objective-c
#import "ABMultiton.h"
...
+ (instancetype)shared
{
    return [ABMultiton sharedInstanceOfClass:self.class withInitBlock:^id
    {
        MyClass *instance = [[MyClass alloc] initWithArgument:value];
        instance.someProperty = propertyValue;
        return instance;
    }];
}
```

##### 3. Remove shared instance
It's very useful in unit tests. So, if you don't need shared instance you can remove it by this call:
```objective-c
[ABMultiton removeInstanceOfClass:MyClass.class];
```

##### 4. Remove shared instance on memory warning 
Sometimes you don't need shared instance for all app life cycle. And you may want to release some shared instances on low memory. It's pretty easy. Just implement optional method `isRemovableInstance` of `ABMultitonProtocol`
```objective-c
@implementation MyClass
...
- (BOOL)isRemovableInstance
{
    return YES;
}
```
And this instance will be released on memory warning. Or you can release all such instances manually by this call:
```objective-c
[ABMultiton purgeRemovableInstances];
```

##### 5. Check is shared instance exists
```objective-c
BOOL isExists = [ABMultiton containsInstanceOfClass:[MyClass class]];
```

##### 6. Thread safety
Using `ABMultiton` is thread safe.

##### 7. Important warning
Please, don't create shared instance for class if you can. "Singleton mania" is a well known anti-pattern.

#### Subspec
**ABMultiton** contain subspec `SetInstance`. It's allow to replace or add instance for class that will return on `shared` method call. It can be very useful with unit-tests.

##### Installation
Replace `pod 'ABMultiton'` with `pod 'ABMultiton/SetInstance'`

##### Using
```objective-c
[ABMultiton setInstance:customInstance forClass:MyClass.class];
```

#### History

**Version 2.0.4**
* Fixed deadlock between different instances.
Thanks to [Alessandro Zummo](https://github.com/dwery) for issue.

**Version 2.0.3**
* Added subspec that allow to set custom shared instance directly.

**Version 2.0.2**
* Fixed critical bug with `shared` method injection.

**Version 2.0.0**
* Added runtime `shared` method injection.

**Version 1.2.2**
* Fixed potential bug with multithread shared instance creation.

#### Updates
Stay tuned with **ABMultiton** updates at [@okolodev](https://twitter.com/okolodev)
