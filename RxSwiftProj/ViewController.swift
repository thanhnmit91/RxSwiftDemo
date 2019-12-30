//
//  ViewController.swift
//  RxSwiftProj
//
//  Created by administrator on 12/20/19.
//  Copyright © 2019 Vision. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import ViewAnimator

class ViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var leadingViewAnimation: NSLayoutConstraint!
    
    @IBOutlet weak var viewAnimationTabbar: UIView!
    
    private let apiCalling = APICalling()
    private let disposeBag = DisposeBag()

    var result : Observable<[countryListModel]>?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tf: UITextField!
    
    let url = "https://api.exchangeratesapi.io/latest?base=EUR&symbols=USD"
    
    let stringObservable = Observable<String>.just("Minh Thành")
    let intObservable = Observable<Int>.of(20,09,91)
    let intObservable1 = Observable<Int>.of(16,11,92)
    let dictObservable = Observable.from(["Key": "Minh", 2: "Thành"])
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    let b = 2
    var c = 0
    
    var a: Int = 1 {
        didSet{
            c = a + b
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let formatter = NSNumberFormatter()
//        formatter.numberStyle = .currencyStyle
//        formatter.currencyCode = "USD"
//        if let fromValue = NSNumberFormatter().numberFromString(self.fromTextField.text!) {

//        services.requestFromAPI(url: url)
        
        viewAnimationTabbar.backgroundColor = .red
        print("self.viewAnimationTabbar.center.x \(self.viewAnimationTabbar.center.x)")
        
        _ = RxAlamofire.requestJSON(.get, url).subscribe(onNext: { [weak self] (r, json) in
            print(json)
        })
        
        RxAlamofire.requestJSON(.get, url)
                        .debug()
                        .subscribe(onNext: { [weak self] (r, json) in
                            if let dict = json as? [String: AnyObject] {
                                let valDict = dict["rates"] as! Dictionary<String, AnyObject>
//                                if let conversionRate = valDict["USD"] as? Float {
//                                    self?.toTextField.text = formatter
//                                        .string(from: NSNumber(value: conversionRate * fromValue))
//                                }
                            }
                            }, onError: { [weak self] (error) in
//                                self?.displayError(error as NSError)
                        })
                        .disposed(by: disposeBag)

//        } else {
//            self.toTextField.text = "Invalid Input!"
//        }
        
        
//        var a = 1
//        let b = 2
//        let c = a + b
//        a = 2
        
        let disposeBag = DisposeBag()
         let dict = dictObservable.subscribe({ (event) in
            switch event{
            case .next(let value):
                print(value)
            case .error(let err):
                print(err)
            case .completed:
                print("completed")
            }
            print(event)
            })
        dict.disposed(by: disposeBag)
        
        _ = intObservable.map { (value) in
            return value + 10
            }.subscribe(onNext: {
                print($0)
        })
        
        _ = dictObservable.map({ (key, value) in
            return value
            }).subscribe(onNext: {
                    print($0)
            })
        
        //filter
        _ = intObservable.map({ (value) in
            return value + 10
        }).filter({ (value) in
            return value > 20
            }).subscribe(onNext: {
                print("Filter: \($0)")
            })
        
        //FlatMap
        let flatMapObservable = Observable.of(intObservable, intObservable1)
        _ = flatMapObservable.flatMap{ return $0 }.subscribe(onNext: {
            print("FlatMap: \($0)")
            })
        
        //        tableView.dataSource = self
        
//        searchBar.rx.text.orEmpty.distinctUntilChanged().throttle(.milliseconds(100), scheduler: MainScheduler.instance) // If they didn't occur, check if the new value is the same as old.
//        .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value
//            self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
//            self.tableView.reloadData() // And reload table view data.
//        })
//        .disposed(by: disposeBag)
        
        tf.rx.text.orEmpty
            .distinctUntilChanged()
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
//            .filter{ !$0.isEmpty }
            .subscribe(onNext: { [unowned self] (query) in
                print("\(query)")
//                self.result = self.result.flatMap({ (res) -> Observable<[countryListModel]>? in
//
//                    return
//                })
//            self.tableView.reloadData()
            }).disposed(by: disposeBag)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityPrototypeCell")
        let request =  APIRequest()
        self.result = self.apiCalling.send(apiRequest: request)
        _ = self.result!.bind(to: self.tableView.rx.items(cellIdentifier: "cityPrototypeCell")) { ( row, model, cell) in
           cell.textLabel?.text = model.name
            UIView.animate(views: self.tableView.visibleCells, animations: self.animations, completion: {
                
            })
        }
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    @IBAction func act(_ sender: Any) {
        a += 1
        print("c=\(c)")
//        self.present(RxAlamofireViewController(), animated: true, completion: nil)
//        let controller = SwiftDemoAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        controller.addAction(UIAlertAction(title: "Reset to default", style: .destructive, handler: nil))
//        controller.addAction(UIAlertAction(title: "Save", style: .cancel, handler: nil))
//
//        self.present(controller, animated: true, completion: nil)
        
//        if let _ = tf.text {
        let url = "param1=Value1&param2=Value2"
        
//        let params = NSMutableDictionary()
//        let kvPairs : [String] = (url.query.componentsSeparatedByString("&"))!
//        for param in  kvPairs{
//            let keyValuePair : Array = param.componentsSeparatedByString("=")
//            if keyValuePair.count == 2{
//                params.setObject(keyValuePair.last!, forKey: keyValuePair.first!)
//            }
//        }
//
        
        if let url = URL(string: String(format: "%@%@","FLCThanhHoa://" , tf.text!)) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
//        }
        
    }
    
    
    @IBAction func actTabbar(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.viewAnimationTabbar.backgroundColor = .blue
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.viewAnimationTabbar.center.x = self.viewAnimationTabbar.bounds.width + self.viewAnimationTabbar.bounds.width/2
                print("=============>\(sender.tag): \(self.viewAnimationTabbar.center.x) - \(self.viewAnimationTabbar.bounds.width)")
            }, completion: nil)
            break
        case 2:
            self.viewAnimationTabbar.backgroundColor = .yellow
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.viewAnimationTabbar.center.x = self.viewAnimationTabbar.frame.width*2 + self.viewAnimationTabbar.bounds.width/2
                print("=============>\(sender.tag): \(self.viewAnimationTabbar.center.x) - \(self.viewAnimationTabbar.bounds.width)")
            }, completion: nil)
            break
        default:
            self.viewAnimationTabbar.backgroundColor = .red
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.viewAnimationTabbar.center.x = self.viewAnimationTabbar.bounds.width/2
                print("=============>\(sender.tag): \(self.viewAnimationTabbar.center.x) - \(self.viewAnimationTabbar.bounds.width)")
            }, completion: nil)
            break
        }
    }
}


class SwiftDemoAlertController: UIAlertController, UITableViewDataSource {
    private var controller : UITableViewController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        controller = UITableViewController(style: .plain)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        controller.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        controller.tableView.dataSource = self
        controller.tableView.addObserver(self, forKeyPath: "contentSize", options: [.initial, .new], context: nil)
        self.setValue(controller, forKey: "contentViewController")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize" else {
            return
        }

        controller.preferredContentSize = controller.tableView.contentSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        controller.tableView.removeObserver(self, forKeyPath: "contentSize")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

        switch(indexPath.row) {
        case 0:
            cell.textLabel?.text = "Upcoming activities"
            let switchView = UISwitch(frame: .zero)
            cell.accessoryView = switchView
            switchView.setOn(true, animated: false)
            break
        case 1:
            cell.textLabel?.text = "Past activities"
            let switchView = UISwitch(frame: .zero)
            cell.accessoryView = switchView
            switchView.setOn(false, animated: false)
            break
        case 2:
            cell.textLabel?.text = "Activities where I am admin"
            let switchView = UISwitch(frame: .zero)
            cell.accessoryView = switchView
            switchView.setOn(true, animated: false)
            break
        case 3:
            cell.textLabel?.text = "Attending"
            let switchView = UISwitch(frame: .zero)
            cell.accessoryView = switchView
            switchView.setOn(true, animated: false)
            break
        case 4:
            cell.textLabel?.text = "Declined"
            let switchView = UISwitch(frame: .zero)
            cell.accessoryView = switchView
            switchView.setOn(true, animated: false)
            break
        case 5:
            cell.textLabel?.text = "Not responded"
            let switchView = UISwitch(frame: .zero)
            cell.accessoryView = switchView
            switchView.setOn(true, animated: false)
            break
        default:
            fatalError()
        }

        return cell
    }
}
