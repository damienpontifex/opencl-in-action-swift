//
//  main.swift
//  MatVec
//
//  Created by Damien Pontifex on 28/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import OpenCL

var mat = [cl_float](count: 16, repeatedValue: 0.0)
var vec = [cl_float](count: 4, repeatedValue: 0.0)
var result = [cl_float](count: 4, repeatedValue: 0.0)
var correct = [cl_float](count: 4, repeatedValue: 0.0)

/* Initialize data to be processed by the kernel */
for i in 0..<16 {
	mat[i] = Float(i) * 2.0;
}
for i in 0..<4 {
	vec[i] = Float(i) * 3.0;
	correct[0] += mat[i]    * vec[i];
	correct[1] += mat[i+4]  * vec[i];
	correct[2] += mat[i+8]  * vec[i];
	correct[3] += mat[i+12] * vec[i];
}

let context = gcl_get_context()
let queue = gcl_create_dispatch_queue(cl_queue_flags(CL_DEVICE_TYPE_CPU), nil)

dispatch_sync(queue) {

	var ndRange = cl_ndrange(
		work_dim: 1,
		global_work_offset: (0, 0, 0),
		global_work_size: (4, 0, 0),
		local_work_size: (0, 0, 0)
	)
	
	var mat_buff = gcl_malloc(sizeof(cl_float) * 16, &mat, cl_malloc_flags(CL_MEM_COPY_HOST_PTR | CL_MEM_READ_ONLY))
	var vec_buff = gcl_malloc(sizeof(cl_float) * 4, &vec, cl_malloc_flags(CL_MEM_COPY_HOST_PTR | CL_MEM_READ_ONLY))
	var res_buff = gcl_malloc(sizeof(cl_float) * 4, nil, cl_malloc_flags(CL_MEM_WRITE_ONLY))
	
	var resC = UnsafeMutablePointer<cl_float>(res_buff)
	var matPointer = UnsafeMutablePointer<cl_float4>(mat_buff)
	var vecPointer = UnsafeMutablePointer<cl_float4>(vec_buff)

	withUnsafePointer(&ndRange) { ndRangePointer -> Void in
		matvec_mult_kernel(ndRangePointer, matPointer, vecPointer, resC)
	}
	
	withUnsafeMutablePointer(&result) {
		gcl_memcpy($0, res_buff, sizeof(cl_float) * 4)
	}
	
	/* Test the result */
	if((result[0] == correct[0]) && (result[1] == correct[1])
		&& (result[2] == correct[2]) && (result[3] == correct[3])) {
			println("Matrix-vector multiplication successful")
	}
	else {
		println("Matrix-vector multiplication unsuccessful")
	}

	gcl_free(mat_buff)
	gcl_free(vec_buff)
	gcl_free(res_buff)
}