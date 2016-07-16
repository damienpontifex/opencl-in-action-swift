//
//  main.swift
//  DeviceExtTest
//
//  Created by Damien Pontifex on 29/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import OpenCL

func getStringInfo(_ deviceId: cl_device_id, deviceInfo: Int32) -> String {
	var valueSize: size_t = 0
	clGetDeviceInfo(deviceId, cl_device_info(deviceInfo), 0, nil, &valueSize)
	var value = Array<CChar>(repeating: CChar(32), count: Int(valueSize))
	clGetDeviceInfo(deviceId, cl_device_info(deviceInfo), valueSize, &value, nil)
	let stringValue = NSString(bytes: &value, length: Int(valueSize), encoding: String.Encoding.ascii.rawValue)
	return stringValue as! String
}

func getNumericalInfo(_ deviceId: cl_device_id, deviceInfo: Int32) -> cl_uint {
	var value = cl_uint(0)
	clGetDeviceInfo(deviceId, cl_device_info(deviceInfo), sizeof(cl_uint.self), &value, nil)
	return value
}

let queue = gcl_create_dispatch_queue(cl_queue_flags(CL_DEVICE_TYPE_GPU), nil)!

let deviceId = gcl_get_device_id_with_dispatch_queue(queue)

let deviceName = getStringInfo(deviceId!, deviceInfo: CL_DEVICE_NAME)
let addressData = getNumericalInfo(deviceId!, deviceInfo: CL_DEVICE_ADDRESS_BITS)
let extData = getStringInfo(deviceId!, deviceInfo: CL_DEVICE_EXTENSIONS)

print("Name: \(deviceName)")
print("Address Width: \(addressData)")
print("Extensions: \(extData)")
