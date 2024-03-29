//
//  ProfileMyPostRepository.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/12.
//

import Foundation

import ReactorKit
import CODomain


protocol ProfileMyPostRepository {
    func responseMyPostStudyItem() -> Observable<ProfileMyPostReactor.Mutation>
    func responseMyPostBookMarkItem() -> Observable<ProfileMyPostReactor.Mutation>
    func responseMyPostSectionItem(item: [ProfileStudy]) -> ProfileMyPostSection
    func responseMyBookMarkSectionItem(item: [ProfileBookMark]) -> ProfileMyPostSection
    func requestMyBookMarkItem(id: String) -> Observable<MyProfileBookMarkListCellReactor.Mutation>
    func requestMyStudyBookMarkItem(id: String) -> Observable<MyProfilePostListCellReactor.Mutation>
}
