

import UIKit
import Validator
import RxSwift
import RxBlocking
import RxCocoa

class StaticTableViewController : UITableViewController {
    
    //MARK:ui
    @IBOutlet weak var firsName: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    //MARK:actions
    @IBAction func onClick(_ sender: AnyObject) {
        print("Click")
    }
    @IBAction func onBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    
    //MARK:lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValidator()
        if self.revealViewController() != nil {
            
            barButton.target = self.revealViewController()
            barButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    // MARK: RX
    let disposeBag = DisposeBag()
    
    //MARK:validator
    var passwordRules = ValidationRuleSet<String>()
    
    func setupValidator(){
        
        let rule = ValidationRulePattern(
            pattern: EmailValidationPattern.standard,
            error: ValidationError(message: "EmailAddress Error")
        )
        let comparisonRule = ValidationRuleLength(
            min: 5,
            max: 30,
            error:  ValidationError(message: "ValidationRuleComparison min: 5, max: 30")
        )
        
        let numbercount = 2
        let containsNumberPattern = ".*\\d{\(numbercount)}.*"
        let containsNumber = ValidationRulePattern(
            pattern: containsNumberPattern,
            error: ValidationError(message: "containsNumber \(numbercount) Error")
        )
        
        passwordRules.add(rule: rule)
        passwordRules.add(rule: comparisonRule)
        passwordRules.add(rule: containsNumber)
        
        errorLabel.isHidden = true
        firsName
            .rx.textInput.text
            .skip(1)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: {text in
                self.validate(text!)
            })
            .addDisposableTo(disposeBag)
    }
    func validate(_ text:String){
        let result: ValidationResult = text.validate(rules: passwordRules)
        
        switch result {
        case .valid:
            print("😀")
            errorLabel.text = "Valid 😀"
        case .invalid(let failures):
            var errorMessages = ""
            for (failure) in failures{
                guard let failure = failure as? ValidationError else {break}
                firsName.layer.borderColor = UIColor.red.cgColor
                firsName.layer.borderWidth = 1.0
                errorMessages += failure.message
                print(failure.message)
            }
            errorLabel.text = errorMessages
            errorLabel.isHidden = false
        }
        
    }
    
    
}

struct ValidationError:Error{
    var message:String
}
