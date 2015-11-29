@isTest
public class TestFactory_Test {
	
	public static Account buildTestAccount(String name) {
		Account ac = new Account();
		ac.Name = name;
		return ac;
	}
    
}