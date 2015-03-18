# FastInvocationCourse

在找不到对应selector的情况下，调用顺序如下:

1.  +(BOOL) resolveInstanceMethos:(SEL)sel    可以override这个函数添加相应的操作，这个函数返回YES 就不会造成crash

-  如果上面函数返回NO，会进行 Message Forwarding(消息转发), 可以override -(id)forwardingTargetForSelector 这个方法，返回你希望让它响应的对象。

-  如果 forwardingTargetForSelector没有对象返回， Runtime会发送 -methodSignatureForSelector: 获取函数参数和返回类型，如果返回nil，Runtime会抛出 doesNotRecognizeSelector ，程序会crash。 如果返回一个NSMethodSignature*, Runtime会创建一个NSInvocation发送给 forwardInvocation消息给目标target。