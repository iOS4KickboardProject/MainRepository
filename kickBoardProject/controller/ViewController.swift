import UIKit
import SnapKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setLoginViewController()
    }
    
    func setLoginViewController(){
        let child = LoginViewController()
        addChild(child)
        self.view.addSubview(child.view)
        child.view.snp.makeConstraints {
            $0.bottom.top.trailing.leading.equalToSuperview()
        }
        child.didMove(toParent: self)
    }

}
