//
//  main.swift
//  DeviceExtTest
//
//  Created by Damien Pontifex on 29/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import OpenCL

func getStringInfo(deviceId: cl_device_id, deviceInfo: Int32) -> String {
	var valueSize: size_t = 0
	clGetDeviceInfo(deviceId, cl_device_info(deviceInfo), 0, nil, &valueSize)
	var value = Array<CChar>(count: Int(valueSize), repeatedValue: CChar(32))
	clGetDeviceInfo(deviceId, cl_device_info(deviceInfo), valueSize, &value, nil)
	let stringValue = NSString(bytes: &value, length: Int(valueSize), encoding: NSASCIIStringEncoding)
	return stringValue as! String
}

func getNumericalInfo(deviceId: cl_device_id, deviceInfo: Int32) -> cl_uint {
	var value = cl_uint(0)
	clGetDeviceInfo(deviceId, cl_device_info(deviceInfo), sizeof(cl_uint), &value, nil)
	return value
}

let queue = gcl_create_dispatch_queue(cl_queue_flags(CL_DEVICE_TYPE_GPU), nil)

let deviceId = gcl_get_device_id_with_dispatch_queue(queue)

let deviceName = getStringInfo(deviceId, CL_DEVICE_NAME)
let addressData = getNumericalInfo(deviceId, CL_DEVICE_ADDRESS_BITS)
let extData = getStringInfo(deviceId, CL_DEVICE_EXTENSIONS)

println("Name: \(deviceName)")
println("Address Width: \(addressData)")
println("Extensions: \(extData)")