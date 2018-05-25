import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    /**
     A place to bind all rx elements in view.
     Gets called after viewDidLoad method.
     Must be overriden.
    */
    func bindUI(){
        fatalError("Must be overriden")
    }

}
