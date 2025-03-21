# MindNet

This is a basic social networking app built using MVVM, which is implemented by Combine framework and RxSwift.

### Screenshots

<img src="https://fir-site-e96f5.web.app/mindnet/home.png" style="height: 440px; width: 204px">|<img src="https://fir-site-e96f5.web.app/mindnet/blur.png" style="height: 440px; width: 204px">|<img src="https://fir-site-e96f5.web.app/mindnet/profile.png" style="height: 440px; width: 204px">|<img src="https://fir-site-e96f5.web.app/mindnet/search.png" style="height: 440px; width: 204px">|
|-|-|-|-|

### Features
* Uploading images
* Liks persistence
* Following users
* Filtering inappropriate content

### Technologies

* MVVM

### [Combine Framework](https://developer.apple.com/documentation/combine)

```swift
    import Combine
    
    @Published var followButtonTitle: String = ""
    @Published var followButtonTitleColour: UIColor = .black
    @Published var followButtonBackgroundColour: UIColor = .white
    
    var followButtonTitleSubscriber: AnyCancellable?
    var followButtonTitleColourSubscriber: AnyCancellable?
    var followButtonBackgroundColourSubscriber: AnyCancellable?
    
    override var item: UserViewModel! {
            didSet {
                profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
                usernameLabel.text = item.fullName
    
                item.followButtonTitleSubscriber = item.$followButtonTitle
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { self.followButton.setTitle($0, for: .normal)})
                
                item.followButtonBackgroundColourSubscriber = item.$followButtonBackgroundColour
                    .receive(on: RunLoop.main)
                    .map({ return $0 })
                    .assign(to: \.backgroundColor, on: followButton)
                
                item.followButtonTitleColourSubscriber = item.$followButtonTitleColour
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { self.followButton.setTitleColor($0, for: .normal) })
            }
    }
```

### [RxSwift](https://github.com/ReactiveX/RxSwift)

```swift
    import RxSwift
    import RxCocoa
    
    struct FollowingViewModel {
        var items = PublishSubject<[User]>()
        
        func fetchFollowing() {
            Service.shared.fetchUsersBeingFollowing { result in
                switch result {
                case .failure(let err):
                    print("Failed to fetch following", err)
                    break
                case.success(let allFollowing):
                    items.onNext(allFollowing)
                    break
                }
            }
        }
    }

    var viewModel = FollowingViewModel()
    fileprivate var bag = DisposeBag()

    // Bind items to collection view
    viewModel.items.bind(to: collectionView.rx.items(cellIdentifier: cellId, cellType: FollowingCell.self))
    { _, model, cell in
        cell.profileImageView.sd_setImage(with: URL(string: model.profileImageUrl ?? ""))
        cell.usernameLabel.text = model.fullName
    }.disposed(by: bag)
        
    // Bind a model selected handler
    collectionView.rx.modelSelected(User.self)
        .bind { user in
        print(user.fullName)
    }.disposed(by: bag)
        
    //fetch items
    viewModel.fetchFollowing()
```

* Unit test
* Programmatic UI

### Third party dependencies
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
* [SDWebImage](https://github.com/SDWebImage/SDWebImage)
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [RxCocoa](https://github.com/ReactiveX/RxSwift)

### Backend
* REST APIs built with NodeJS/TypeScript (ExpressJS)
* Nginx
* MongoDB Atlas
* AWS S3
* Jest for unit testing
* Linux Ubuntu 22.04 VM
