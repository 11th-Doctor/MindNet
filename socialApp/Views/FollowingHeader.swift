//
//  HomeHeader.swift
//  socialApp
//
//  Created by Daryl on 2021/8/25.
//

import UIKit
import RxSwift
import RxCocoa

class FollowingHeader: UICollectionReusableView {
    
    let cellId = "cellId"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "追蹤中"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        return view
    }()
    
    var parentViewController: UIViewController?
    
    var viewModel = FollowingViewModel()
    
    fileprivate var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bindCollectionData()
    }
    
    func bindCollectionData() {
        // Bind items to collection view
        viewModel.items.bind(to: collectionView.rx.items(cellIdentifier: cellId, cellType: FollowingCell.self))
        { _, model, cell in
            cell.profileImageView.sd_setImage(with: URL(string: model.profileImageUrl ?? ""))
            cell.usernameLabel.text = model.fullName
        }.disposed(by: bag)
        
        // Bind a model selected handler
        collectionView.rx.modelSelected(User.self)
            .bind { user in
                self.viewModel.didSelectItem(withId: user._id)
        }.disposed(by: bag)
        
        //fetch items
        viewModel.fetchFollowing()
    }
    
    fileprivate func setupViews() {
        
        collectionView.delegate = self
        
        collectionView.register(FollowingCell.self, forCellWithReuseIdentifier: cellId)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(separatorView)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: separatorView.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FollowingHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: height, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}

extension FollowingHeader: UICollectionViewDelegate {
    
}
