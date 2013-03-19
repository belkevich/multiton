[Multiton pattern](http://en.wikipedia.org/wiki/Multiton_pattern) implementation in Objective-C
========
---
# About
It is not implementation of classic multiton. This implementation uses instance `class name` as `key` to access instance.

# Installation

Add multiton to project as submodule

```
cd <project source directory>
git submodule add https://github.com/belkevich/multiton.git <submodules directory>
```

# Using

## Prepare class

1. Class should conforms to `ABMultitonProtocol`
```objective-c
#import "ABMultitonProtocol.h"
...
@interface MyClass : ParentClass <ABMultitonProtocol>
...
@end
```

2. Class should implement `sharedInstance` method in this way:
```objective-c
#import "ABMultiton.h"
...
@implementation MyClass
...
+ (id)sharedIsntance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}
```

3. Class should use `init` method for initialization. No Arguments!

## Get shared instance

```objective-c
MyClass *instance = [MyClass sharedInstance];
```

## Removing class instance from multiton

If you don't need shared instance anymore you can remove it by this call:
```objective-c
[ABMultiton removeInstanceOfClass:yourClass];
```

## Advanced instance management

Sometimes you don't need shared instance for all app life cycle.
And you may want to release some shared instances on low memory.
It's pretty easy. Just implement optional method `isRemovableInstance`
of `ABMultitonProtocol`
```objective-c
@implementation MyClass
...
- (BOOL)isRemovableInstance
{
    return YES;
}
```
And this instance will be released on memory warning.
Or you can release all such instances
```objective-c
[ABMultiton purgeRemovableInstances];
```

## Thread safety

Using `ABMultiton` is thread safe.

# Important warning

Please, don't create shared instance for class if you can.
"Singleton mania" is a well known anti-pattern.
