[Multiton pattern](http://en.wikipedia.org/wiki/Multiton_pattern) implementation in Objective-C
========
---
# About
It is not implementation of classical multiton. This implementation uses instance `class name` as `key` to access instance.

# Installation

Add multiton to project as submodule

`cd <project source directory>`
`git submodule add https://github.com/belkevich/multiton.git <submodules directory>`

# Adding class instance to multiton

###### Prepare class

1. Class should conforms to `ABSingletonProtocol`

```objective-c
@interface MyClass : ParentClass <ABSingletonProtocol>
...
@end
```

2. Class should implement in `sharedInstance` method:

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

3. Class should use default `init` method for initialization

###### Using

```
MyClass *instance = [MyClass sharedInstance];
```

# Important warning

Using ABMultiton is not thread-safe! Thread-safe using will be added in future
