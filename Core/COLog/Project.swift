//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2022/12/13.
//
import Foundation
import ProjectDescription
import ProjectDescriptionHelpers


let log = Project.feature(
    name: "COLog",
    products: [.framework(.dynamic)],
    dependencies: [
        .ThirdParty.Log.googleAnalytics
    ]
)
