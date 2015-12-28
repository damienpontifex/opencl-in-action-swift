import SwiftOpenCL
#if os(Linux)
//TODO: Add OpenCL module import for Linux
#else
import OpenCL
#endif

let platforms = Platform.allPlatforms()

for platform in platforms
{
    guard let extensions = platform.getInfo(CL_PLATFORM_EXTENSIONS) else {
        continue
    }
    
    print(extensions)
}