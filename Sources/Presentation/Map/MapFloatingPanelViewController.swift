//
//  BottomFloatingPanelViewController.swift
//  connect
//
//  Created by 이건준 on 2022/06/28.
//  Copyright © 2022 sideproj. All rights reserved.
//

import FloatingPanel
import SnapKit
import UIKit

class MapFloatingPanelViewController: UIViewController {
    
    private lazy var studyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 292 - 30, height: 292 - 30)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 25, left: 22, bottom: 10, right: 22)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setCollectionView(with: studyCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        studyCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: -Configure
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(studyCollectionView)
    }
    
    private func setCollectionView(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: StudyCollectionViewCell.identifer)
    }
}

//MARK: - UICollectionViewDataSource
extension MapFloatingPanelViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudyCollectionViewCell.identifer, for: indexPath) as? StudyCollectionViewCell ?? StudyCollectionViewCell()
        cell.configureUI(with: "")
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MapFloatingPanelViewController: UICollectionViewDelegate {
    
}

extension MapFloatingPanelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
