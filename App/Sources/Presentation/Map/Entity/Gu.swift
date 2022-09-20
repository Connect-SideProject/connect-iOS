//
//  Gu.swift
//  connect
//
//  Created by 이건준 on 2022/07/13.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

enum Gu {
    case 강남구(Int)
    case 강동구(Int)
    case 강북구(Int)
    case 강서구(Int)
    case 관악구(Int)
    case 광진구(Int)
    case 구로구(Int)
    case 금천구(Int)
    case 노원구(Int)
    case 도봉구(Int)
    case 동대문구(Int)
    case 동작구(Int)
    case 마포구(Int)
    case 서대문구(Int)
    case 서초구(Int)
    case 성동구(Int)
    case 성북구(Int)
    case 송파구(Int)
    case 양천구(Int)
    case 영등포구(Int)
    case 용산구(Int)
    case 은평구(Int)
    case 종로구(Int)
    case 중구(Int)
    case 중랑구(Int)
    
    var countText: String {
        switch self {
        case .강남구(let count):
            return "강남구 \(count)명"
        case .강동구(let count):
            return "강동구 \(count)명"
        case .강북구(let count):
            return "강북구 \(count)명"
        case .강서구(let count):
            return "강서구 \(count)명"
        case .관악구(let count):
            return "관악구 \(count)명"
        case .광진구(let count):
            return "광진구 \(count)명"
        case .구로구(let count):
            return "구로구 \(count)명"
        case .금천구(let count):
            return "금천구 \(count)명"
        case .노원구(let count):
            return "노원구 \(count)명"
        case .도봉구(let count):
            return "도봉구 \(count)명"
        case .동대문구(let count):
            return "동대문구 \(count)명"
        case .동작구(let count):
            return "동작구 \(count)명"
        case .마포구(let count):
            return "마포구 \(count)명"
        case .서대문구(let count):
            return "서대문구 \(count)명"
        case .서초구(let count):
            return "서초구 \(count)명"
        case .성동구(let count):
            return "성동구 \(count)명"
        case .성북구(let count):
            return "성북구 \(count)명"
        case .송파구(let count):
            return "송파구 \(count)명"
        case .양천구(let count):
            return "양천구 \(count)명"
        case .영등포구(let count):
            return "영등포구 \(count)명"
        case .용산구(let count):
            return "용산구 \(count)명"
        case .은평구(let count):
            return "은평구 \(count)명"
        case .종로구(let count):
            return "종로구 \(count)명"
        case .중구(let count):
            return "중구 \(count)명"
        case .중랑구(let count):
            return "중랑구 \(count)명"
        }
    }
}
