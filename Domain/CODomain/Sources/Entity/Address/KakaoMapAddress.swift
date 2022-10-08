//
//  MapAddress.swift
//  connect
//
//  Created by 이건준 on 2022/06/29.
//  Copyright © 2022 sideproj. All rights reserved.
//

/*
 https://dapi.kakao.com/v2/local/search/address.json?query=역삼
 Authorization KakaoAK ccd2be71137221d2c9eac97cee497f1a
 주소검색에 따른 위치를 마커로 찍어주기위한 카카오 API
 */
public struct KakaoMapAddresses: Decodable {
  public let documents: [KakaoMapAddress]
}

public struct KakaoMapAddress: Decodable {
  public let address: Address?
  public let addressName: String
  let addressType: String?
  let roadAddress: String?
  let x: String
  let y: String
  
  enum CodingKeys: String, CodingKey {
    case address, x, y
    case addressName = "address_name"
    case addressType = "address_type"
    case roadAddress = "road_address"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.address = try? values.decode(Address.self, forKey: .address)
    self.addressName = (try? values.decode(String.self, forKey: .addressName)) ?? ""
    self.addressType = try? values.decode(String.self, forKey: .addressType)
    self.roadAddress = try? values.decode(String.self, forKey: .roadAddress)
    self.x = (try? values.decode(String.self, forKey: .x)) ?? ""
    self.y = (try? values.decode(String.self, forKey: .y)) ?? ""
  }
}

public struct Address: Decodable {
  public let addressName:String
  public let bCode: String
  let hCode: String
  let mainAddressNo: String
  let mountainYn: String
  let region1depthName: String
  let region2depthName: String
  let region3depthHName: String
  let region3depthName: String
  let subAddressNo: String
  let x: String
  let y: String
  
  enum CodingKeys: String, CodingKey {
    case x, y
    case addressName = "address_name"
    case bCode = "b_code"
    case hCode = "h_code"
    case mainAddressNo = "main_address_no"
    case mountainYn = "mountain_yn"
    case region1depthName = "region_1depth_name"
    case region2depthName = "region_2depth_name"
    case region3depthHName = "region_3depth_h_name"
    case region3depthName = "region_3depth_name"
    case subAddressNo = "sub_address_no"
  }
}
