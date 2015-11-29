@isTest
public class WSAccountHandler_Test {

	@isTest
    private static void getAccount() {
    	
    	Account ac = TestFactory_Test.buildTestAccount('Unit Testing Account');
    	insert ac;

    	RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		WSUtil.WsResponse wsResponse;

		req.requestURI = '/services/apexrest/WSAccountHandler.do/GET/' + ac.Id;  //Request URL
		req.httpMethod = 'GET';//HTTP Request Type
		RestContext.request = req;
		RestContext.response= res;
		WSAccountHandler.getActionRouter();

		wsResponse = (WSUtil.WsResponse)JSON.deserialize(res.responseBody.toString(), WSUtil.WsResponse.class);
		Account accNew = (Account)JSON.deserialize(wsResponse.response, Account.class);
		System.debug(wsResponse.status);
		System.assertEquals(ac.Id, accNew.Id);
    	
    }


	@isTest(seeAllData=true)
	private static void getAccounts() {
	
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		WSUtil.WsResponse wsResponse;

		req.requestURI = '/services/apexrest/WSAccountHandler.do/GET_ALL';  //Request URL
		req.httpMethod = 'GET';//HTTP Request Type
		RestContext.request = req;
		RestContext.response= res;

		Test.startTest();
		WSAccountHandler.getActionRouter();
		wsResponse = (WSUtil.WsResponse)JSON.deserialize(res.responseBody.toString(), WSUtil.WsResponse.class);
		List<Account> accList = (List<Account>)JSON.deserialize(wsResponse.response, List<Account>.class);
		List<Account> expectedAccList = [SELECT Id, Name, NumberOfEmployees, (SELECT Id,FirstName,LastName,Email FROM Contacts) FROM Account];
		Test.stopTest();
		
		System.assertEquals(expectedAccList, accList);
	
	}


	@isTest
	private static void createAccount() {

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		WSUtil.WsResponse wsResponse;

		req.requestURI = '/services/apexrest/WSAccountHandler.do/CREATE_ACCOUNT';  //Request URL
		req.httpMethod = 'POST'; //HTTP Request Type
		req.requestBody = blob.valueOf('{"Name": "REST Create Account Testing"}');
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		WSAccountHandler.postActionRouter();
		wsResponse = (WSUtil.WsResponse)JSON.deserialize(res.responseBody.toString(), WSUtil.WsResponse.class);
		Test.stopTest();

		System.debug('WSAccountHandler_Test.createAccount() Response ==>' + wsResponse);
		System.assertEquals(true, wsResponse.status);
	}
	
	@isTest
	private static void createAccountJSONFilure() {

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		WSUtil.WsResponse wsResponse;

		req.requestURI = '/services/apexrest/WSAccountHandler.do/CREATE_ACCOUNT';  //Request URL
		req.httpMethod = 'POST'; //HTTP Request Type
		req.requestBody = blob.valueOf('{"abdcd": "REST Create Account Testing"}');
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		WSAccountHandler.postActionRouter();
		wsResponse = (WSUtil.WsResponse)JSON.deserialize(res.responseBody.toString(), WSUtil.WsResponse.class);
		Test.stopTest();

		System.debug('WSAccountHandler_Test.createAccountJSONFilure() Response ==>' + wsResponse);
		System.assertEquals('INPUT_JSON_STRUCTURE_ERROR_FOR_THIS_ACTION', wsResponse.message);
	}
	
	
	@isTest
	private static void updateAccount() {

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		WSUtil.WsResponse wsResponse;

		req.requestURI = '/services/apexrest/WSAccountHandler.do/UPDATE_ACCOUNT';  //Request URL
		req.httpMethod = 'POST'; //HTTP Request Type

		Test.startTest(); //Start Test execution
		Account ac = TestFactory_Test.buildTestAccount('Unit Testing Account');
    	insert ac;

		req.requestBody = blob.valueOf('{"Id":"' + ac.Id + '","Name": "REST Create Account Testing"}');
		RestContext.request = req;
		RestContext.response = res;
		WSAccountHandler.postActionRouter();
		wsResponse = (WSUtil.WsResponse)JSON.deserialize(res.responseBody.toString(), WSUtil.WsResponse.class);
		System.debug('WSAccountHandler_Test.updateAccount() Response ==>' + wsResponse);
		Account accUpdated = (Account)JSON.deserialize(wsResponse.response, Account.class);
		Test.stopTest(); //Stop Test Execution

		System.assertEquals('REST Create Account Testing', accUpdated.Name);
	}
	
	
	@isTest
	private static void postActionNotSupportedFailure() {

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		WSUtil.WsResponse wsResponse;

		req.requestURI = '/services/apexrest/WSAccountHandler.do/CREATE_ACCOUNTYYYYY';  //Request URL
		req.httpMethod = 'POST'; //HTTP Request Type
		req.requestBody = blob.valueOf('{"abdcd": "REST Create Account Testing"}');
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		WSAccountHandler.postActionRouter();
		wsResponse = (WSUtil.WsResponse)JSON.deserialize(res.responseBody.toString(), WSUtil.WsResponse.class);
		Test.stopTest();

		System.debug('WSAccountHandler_Test.postActionNotSupportedFailure() Response ==>' + wsResponse);
		System.assertEquals(false, wsResponse.status);
	}
}