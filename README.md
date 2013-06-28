[Multiton pattern](http://en.wikipedia.org/wiki/Multiton_pattern) implementation in Objective-C
========

## About
It is not implementation of classic multiton. This implementation uses instance `class name` as `key` to access instance.
The most common way to use multiton is a singleton creation with several advantages:
* Remove shared instance when you don't need it anymore
* Use both shared instance and regular instances of the same class
* Create shared instance with custom `init` method with arguments 

---

## Installation

#### Install with [cocoa pods](http://cocoapods.org/) 
Add to [Podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile)
```
pod 'ABMultiton'
```

And run command
```
pod install
```
---

#### Install as Git submodule
```
cd <project source directory>
git submodule add https://github.com/belkevich/multiton.git <submodules directory>
```
And if you project don't uses ARC you should convert ABMultiton.m file to ARC.

---

## Using

#### Prepare class
Class should conforms to `ABMultitonProtocol`

```objective-c
#import "ABMultitonProtocol.h"
...
@interface MyClass : ParentClass <ABMultitonProtocol>
...
@end
```

Class should implement `sharedInstance` method for default `init` in this way:

```objective-c
#import "ABMultiton.h"
...
@implementation MyClass
...
+ (instancetype)sharedIsntance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}
```

Class should implement `sharedInstance` method for custom `init` in this way:

```objective-c
...
+ (instancetype)sharedIsntance
{
    return [ABMultiton sharedInstanceOfClass:[seld class]
                               withInitBlock:^id
    {
        return [[self alloc] initWithSomeArgument:argument];
    }];
}
...
```

---

#### Get shared instance
```objective-c
MyClass *instance = [MyClass sharedInstance];
```
---

#### Removing class instance from multiton
If you don't need shared instance anymore you can remove it by this call:
```objective-c
[ABMultiton removeInstanceOfClass:[MyClass class]];
```
---

#### Check is shared instance exists
```objective-c
BOOL isExists = [ABMultiton containsInstanceOfClass:[MyClass class]];
```
---

#### Advanced instance management
Sometimes you don't need shared instance for all app life cycle. And you may want to release some shared instances on low memory. It's pretty easy. Just implement optional method `isRemovableInstance` of `ABMultitonProtocol`
```objective-c
@implementation MyClass
...
- (BOOL)isRemovableInstance
{
    return YES;
}
```
And this instance will be released on memory warning. Or you can release all such instances manually
```objective-c
[ABMultiton purgeRemovableInstances];
```
---

#### Thread safety
Using `ABMultiton` is thread safe.

---

#### Important warning
Please, don't create shared instance for class if you can. "Singleton mania" is a well known anti-pattern.

---

## Updates
Stay tuned with `ABMultiton` updates on [@okolodev](https://twitter.com/okolodev)
