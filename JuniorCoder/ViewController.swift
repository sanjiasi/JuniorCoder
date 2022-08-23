//
//  ViewController.swift
//  JuniorCoder
//
//  Created by GLA on 2022/8/17.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var textFld: UITextField!
    @IBOutlet weak var rxBtn: UIButton!
    @IBOutlet weak var rxScrollView: UIScrollView!
    
    var rxStuent: RxStudent = RxStudent()
    let disposeBag = DisposeBag()
    var rxTimer: Observable<Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKVO()
        setupButton()
        setupTextFiled()
        setupScrollerView()
        setupGestureRecognizer()
        setupNotification()
        setupTimer()
        setupNetwork()
        
    }
    
    //MARK: - 触摸空白处
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.rxStuent.age += 1
        print("一年又一年")
        self.textFld.resignFirstResponder()
    }
    
    //MARK: - RxSwift应用
    //MARK: - KVO
    func setupKVO() {
        self.rxStuent.rx.observeWeakly(Int.self, "age")
            .subscribe { value in
                print("\(self.rxStuent.name) is \(value) old")
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - button响应
    func setupButton() {
        self.rxBtn.rx.tap
            .subscribe { _ in
                print("you click done")
            }
            .disposed(by: disposeBag)
        self.rxBtn.rx.controlEvent(.touchDown)
            .subscribe { _ in
                print("touch down")
            }
            .disposed(by: disposeBag)
        self.rxBtn.rx.controlEvent(.touchCancel)
            .subscribe { _ in
                print("touch cancel")
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - textfiled
    func setupTextFiled() {
        self.textFld.rx.text.orEmpty.changed
            .subscribe { text in
                print(text)
            }
            .disposed(by: disposeBag)
        
        self.textFld.rx.text.changed// changed 在textfile有变化时才触发值绑定，没有changed则在初始化序列时触发
            .bind(to: self.rxBtn.rx.title())
            .disposed(by: disposeBag)
        
        self.textFld.rx.text.changed
            .bind(to: self.titleLab.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    //MARK: - scrollView
    func setupScrollerView() {
        self.rxScrollView.rx.contentOffset.changed
            .subscribe { [weak self]contentSet  in
                self?.view.backgroundColor = UIColor.init(red: contentSet.y/255.0 * 0.2, green: contentSet.y/255.0 * 0.4, blue: contentSet.y/255.0 * 0.6, alpha: 1)
            }
            .disposed(by: disposeBag)
    }
    
    
    //MARK: - 手势
    func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer()
        self.titleLab.addGestureRecognizer(tap)
        self.titleLab.isUserInteractionEnabled = true
        tap.rx.event.subscribe { sender in
            print(sender.view!)
        }
        .disposed(by: disposeBag)
    }
    
    //MARK: - 通知
    func setupNotification() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe { noti in
                print(noti)
            }
            .disposed(by: disposeBag)

    }
    
    //MARK: - timer定时器
    func setupTimer() {
        rxTimer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        rxTimer.subscribe { num in
            print(num)
        }
        .disposed(by: disposeBag)
    }
    
    //MARK: - 网络请求
    func setupNetwork() {
        let url: URL! = URL(string: "https://www.baidu.com")
        URLSession.shared.rx.response(request: URLRequest(url: url))
            .subscribe { response, data in
                print(response)
            }
            .disposed(by: disposeBag)
    }
    
}

