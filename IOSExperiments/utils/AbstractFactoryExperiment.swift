class AbstractFactoryExperiment {
    init() {
        
        
        //-----------------------------------------------------------------------------
        let screenExper = createScreenFromAbstractClassWithFactory(AppScreenFactroy())//Dependensy injection
        print(screenExper.title())
        print(screenExper.subTitle())
        print(screenExper.screenId())
        
        testFactoryFromInternet()
        //--------------------------------
    }
    
    
    func createScreenFromAbstractClassWithFactory(_ factory:ScreenFactroy) -> Screen_Abstract{
        print("experiment Factory")
        return factory.makeScreen()
    }
    
    func testFactoryFromInternet(){
        
        print("factory from internet")
        //usage
        let factoryOne = NumberHelper.factoryFor(.nextStep)
        let numberOne = factoryOne("1")
        print(numberOne.stringValue())
        
        let factoryTwo = NumberHelper.factoryFor(.swift)
        let numberTwo = factoryTwo("2")
        print(numberTwo.stringValue())
    }
}




//--------------------------------
//abstr
protocol ScreenFactroy{
    func makeScreen() -> Screen_Abstract
}

protocol Screen_Abstract{
    func title() -> String
    func subTitle() -> String
    func screenId() -> String
}

//Concr
class AppScreenFactroy : ScreenFactroy{
    func makeScreen() -> Screen_Abstract {
        return AppScreenExperiment(
            title: "Google Images title",
            subTitle: "Google Images subTitle",
            screenId: "Google Images screenId"
        )
    }
}
class AppScreenExperiment : Screen_Abstract{
    var screen : Screen
    init(
        title : String,
        subTitle : String,
        screenId : String
        ){
            screen = Screen()
            screen.title = title
            screen.subTitle = subTitle
            screen.screenId = screenId
    }
    
    func title() -> String {
        return screen.title
    }
    func subTitle() -> String {
        return screen.subTitle
    }
    func screenId() -> String {
        return screen.screenId ?? "no ID"
    }
}



//-------Fabric From Internet-------------------------
//Protocols
protocol Decimal {
    func stringValue() -> String
    // factory
    static func make(_ string : String) -> Decimal
}

typealias NumberFactory = (String) -> Decimal

// Number implementations with factory methods

struct NextStepNumber : Decimal {
    fileprivate var nextStepNumber : NSNumber
    
    func stringValue() -> String { return "\(nextStepNumber) NextStepNumber" }
    
    // factory
    static func make(_ string : String) -> Decimal {
        return NextStepNumber(nextStepNumber:NSNumber(value: (string as NSString).longLongValue as Int64))
    }
}

struct SwiftNumber : Decimal {
    fileprivate var swiftInt : Int
    
    func stringValue() -> String { return "\(swiftInt) SwiftNumber" }
    
    // factory
    static func make(_ string : String) -> Decimal {
        return SwiftNumber(swiftInt:(string as NSString).integerValue)
    }
}

//Abstract factory
enum NumberType {
    case nextStep, swift
}

class NumberHelper {
    class func factoryFor(_ type : NumberType) -> NumberFactory {
        switch type {
        case .nextStep:
            return NextStepNumber.make
        case .swift:
            return SwiftNumber.make
        }
    }
}
