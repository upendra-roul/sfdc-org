public with sharing class Page1ControllerExtenstions {

    public Page1ControllerExtenstions(ApexPages.StandardController controller) {

    }
    
    
    public Integer counter {get; private set;} {counter = 0;}
    
    
    public PageReference customButtonAction(){
    
        counter = counter +1;
        return null;
    
    }

}