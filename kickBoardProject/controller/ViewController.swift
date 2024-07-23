import UIKit
import SnapKit
class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiSampleVC = MainViewController()
        addChild(apiSampleVC)
        view.addSubview(apiSampleVC.view)
        apiSampleVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        apiSampleVC.didMove(toParent: self)
    }

}
