//
//  main.swift
//  MatVec
//
//  Created by Damien Pontifex on 28/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import OpenCL

var mat = [cl_float](repeating: 0.0, count: 16)
var vec = [cl_float](repeating: 0.0, count: 4)
var result = [cl_float](repeating: 0.0, count: 4)
var correct = [cl_float](repeating: 0.0, count: 4)

/* Initialize data to be processed by the kernel */
for i in 0..<16 {
	mat[i] = cl_float(i) * 2.0;
}
for i in 0..<4 {
	vec[i] = cl_float(i) * 3.0;
	correct[0] += mat[i]    * vec[i];
	correct[1] += mat[i+4]  * vec[i];
	correct[2] += mat[i+8]  * vec[i];
	correct[3] += mat[i+12] * vec[i];
}

let context = gcl_get_context()
let queue = gcl_create_dispatch_queue(cl_queue_flags(CL_DEVICE_TYPE_GPU), nil)!

queue.sync {

	var ndRange = cl_ndrange(
		work_dim: 1,
		global_work_offset: (0, 0, 0),
		global_work_size: (4, 0, 0),
		local_work_size: (0, 0, 0)
	)
	
    guard var mat_buff = gcl_malloc(sizeof(cl_float.self) * 16, &mat, cl_malloc_flags(CL_MEM_COPY_HOST_PTR | CL_MEM_READ_ONLY)),
        var vec_buff = gcl_malloc(sizeof(cl_float.self) * 4, &vec, cl_malloc_flags(CL_MEM_COPY_HOST_PTR | CL_MEM_READ_ONLY)),
        var res_buff = gcl_malloc(sizeof(cl_float.self) * 4, nil, cl_malloc_flags(CL_MEM_WRITE_ONLY)) else {
            exit(1)
    }
	
	var resC = UnsafeMutablePointer<cl_float>(res_buff)
	var matPointer = UnsafeMutablePointer<cl_float4>(mat_buff)
	var vecPointer = UnsafeMutablePointer<cl_float4>(vec_buff)

	withUnsafePointer(&ndRange) {
		matvec_mult_kernel($0, matPointer, vecPointer, resC)
	}
	
	gcl_memcpy(&result, res_buff, sizeof(cl_float.self) * 4)
	
	/* Test the result */
	if(result == correct) {
		print("Matrix-vector multiplication successful")
	}
	else {
		print("Matrix-vector multiplication unsuccessful")
	}

	gcl_free(mat_buff)
	gcl_free(vec_buff)
	gcl_free(res_buff)
}
