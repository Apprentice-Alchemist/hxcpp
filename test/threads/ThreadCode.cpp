#include <hx/Native.h>

#include <thread>

void threadFunc()
{
   printf("In thread\n");
   hx::NativeAttach attach;
   Test_obj::callFromThread();
}

void runThread()
{
   std::thread(threadFunc).detach();
}

