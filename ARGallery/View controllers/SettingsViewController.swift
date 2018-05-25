import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension SettingsViewController{
    func setupUI(){
        self.title = "Settings"
        self.view.backgroundColor = R.Color.dark_blue_color
        self.navigationController?.navigationBar.tintColor = .white
    }
}
