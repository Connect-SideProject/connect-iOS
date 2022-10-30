//
//  AddressService.swift
//  COManager
//
//  Created by sean on 2022/10/27.
//

import Foundation

import CODomain

public protocol AddressService {  
  var addressList: [법정주소] { get }
}
