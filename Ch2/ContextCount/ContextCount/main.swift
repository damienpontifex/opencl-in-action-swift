//
//  main.swift
//  ContextCount
//
//  Created by Damien Pontifex on 23/12/2015.
//  Copyright © 2015 Pontifex. All rights reserved.
//

import OpenCL

var platform: cl_platform_id = COpaquePointer()
var device: cl_device_id = COpaquePointer()
var context: cl_context
var err: cl_int = CL_SUCCESS
var refCount: cl_uint = 0

// Access the first installed platforms

withUnsafeMutablePointer(&platform) {
	err = clGetPlatformIDs(1, $0, nil)
	if (err != CL_SUCCESS) {
		print("Couldn't find any platforms")
		exit(1)
	}
}

// Access the first available device
var queue = gcl_create_dispatch_queue(cl_queue_flags(CL_DEVICE_TYPE_GPU), nil)
if (queue == nil) {
	queue = gcl_create_dispatch_queue(cl_queue_flags(CL_DEVICE_TYPE_CPU), nil)
}
guard let queue = queue else {
	print("Couldn't find any devices")
	exit(1)
}

device = gcl_get_device_id_with_dispatch_queue(queue)

// Create the context
context = clCreateContext(nil, 1, &device, nil, nil, &err)
if (err != CL_SUCCESS) {
	print("Couldn't create a context")
	exit(1)
}

// Determine the reference count
err = clGetContextInfo(context, cl_context_info(CL_CONTEXT_REFERENCE_COUNT), sizeofValue(refCount), &refCount, nil)
if (err != CL_SUCCESS) {
	print("Couldn't read the reference count")
	exit(1)
}
print("Initial reference count \(refCount)")

// Update and display the reference count
clRetainContext(context);						
clGetContextInfo(context, cl_context_info(CL_CONTEXT_REFERENCE_COUNT), sizeofValue(refCount), &refCount, nil)	
print("Reference count: \(refCount)")

clReleaseContext(context);						
clGetContextInfo(context, cl_context_info(CL_CONTEXT_REFERENCE_COUNT), sizeofValue(refCount), &refCount, nil)	
print("Reference count: \(refCount)")

clReleaseContext(context);