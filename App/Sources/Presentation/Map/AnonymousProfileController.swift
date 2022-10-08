//
//  ProfileController.swift
//  connect
//
//  Created by 이건준 on 2022/08/05.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

class AnonymousProfileController: UIViewController {
    
    private let anonymousProfileModel: [String] // 익명 프로필화면을 표현하기위한 유저의 정보를 받을 모델
    
    let model = ["Figma", "Photoshop", "illustrator", "Zeplin", "Notion", "XD", "Jira"]
    
    private let profileImageView: UIImageView = {
        $0.backgroundColor = .systemGray
        $0.image = UIImage(systemName: "person.fill")
        $0.layer.cornerRadius = 30
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.text = "익명의 커넥터3"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        return $0
    }(UILabel())
    
    private let roleLabel: UILabel = {
        $0.text = "기획자/디자이너/마케터"
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        return $0
    }(UILabel())
    
    private let chattingButton: UIButton = {
        $0.setTitle("채팅하기", for: .normal)
        $0.setTitleColor(UIColor.systemGray, for: .normal)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.titleLabel?.textAlignment = .center
        return $0
    }(UIButton())
    
    private lazy var leftStackView: UIStackView = {
        $0.spacing = 20
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillEqually
        return $0
    }(UIStackView(arrangedSubviews: [ activityAreaTagLabel, interestFieldTagLabel, careerTagLabel, getSkillTagLabel ]))
    
    private lazy var rightStackView: UIStackView = {
        $0.spacing = 20
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fillEqually
        return $0
    }(UIStackView(arrangedSubviews: [ activityAreaLabel, interestFieldLabel, careerLabel, getSkillLabel ]))
    
    private let activityAreaTagLabel = GrayNormalLabel(text: "활동지역")
    private let activityAreaLabel = GrayNormalLabel()
    
    private let interestFieldTagLabel = GrayNormalLabel(text: "관심분야")
    private let interestFieldLabel = GrayNormalLabel()
    
    private let careerTagLabel = GrayNormalLabel(text: "경력")
    private let careerLabel = GrayNormalLabel()
    
    private let getSkillTagLabel = GrayNormalLabel(text: "보유스킬")
    private let getSkillLabel = GrayNormalLabel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init(anonymousProfileModel: [String]) {
        self.anonymousProfileModel = anonymousProfileModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setCollectionView(with: collectionView)
        setNavigationBar()
        
        // 아직 디비에 데이터를 받지못하므로 배열의 요소에 접근해 MockData를 뿌려주기위한 코드
        activityAreaLabel.text = anonymousProfileModel[0]
        interestFieldLabel.text = anonymousProfileModel[1]
        careerLabel.text = anonymousProfileModel[2]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.centerY)
            make.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        roleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.centerY).offset(5)
            make.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        chattingButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.left.equalTo(chattingButton.snp.left)
            make.top.equalTo(chattingButton.snp.bottom).offset(30)
            make.width.equalTo(60)
        }
        
        rightStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(leftStackView)
            make.left.equalTo(leftStackView.snp.right)
            make.right.equalTo(chattingButton.snp.right)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(leftStackView.snp.left)
            make.right.equalTo(rightStackView.snp.right)
            make.top.equalTo(leftStackView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        _ = [profileImageView, nameLabel, roleLabel, chattingButton, leftStackView, rightStackView, collectionView].map{ view.addSubview($0) }
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                                 target: self,
                                                                 action: #selector(didTappedRightBarButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                                                style: .done, target: self,
                                                                action: #selector(didTappedLeftBarButton))
    }
    
    private func setCollectionView(with collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AnonymousProfileCollectionViewCell.self, forCellWithReuseIdentifier: AnonymousProfileCollectionViewCell.identifier)
    }
    
    @objc private func didTappedRightBarButton() {
        
    }
    
    @objc private func didTappedLeftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AnonymousProfileController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count // skill을 표시하기위한 갯수는 이후 Entity모델을 이용해야함, 현재는 고정값 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnonymousProfileCollectionViewCell.identifier, for: indexPath) as? AnonymousProfileCollectionViewCell ?? AnonymousProfileCollectionViewCell()
        cell.configureUI(with: model[indexPath.row])
        return cell
    }
}

extension AnonymousProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
