module vcl

#flag linux -lOpenCL
#flag windows -lOpenCL
#flag darwin -framework OpenCL

$if darwin {
	#include <OpenCL/opencl.h>
} $else {
	#include <CL/cl.h>
}
