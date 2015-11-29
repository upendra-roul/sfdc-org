@RestResource(urlMapping='/WSAccountHandler.do/*')
global with sharing class WSAccountHandler {

	global static RestRequest req;
	global static RestResponse resp;
	global static Account reqBody;
	global static WSUtil.WsResponse respBody;

	global static List<String> actionDetails;

    @HttpPost
    global static void postActionRouter() {

    	req = RestContext.request;
		resp = RestContext.response;

		try{

			reqBody = (Account)JSON.deserializeStrict(req.requestBody.toString(), Account.class);
			actionDetails = req.requestURI.substringAfter('.do/').split('/');
			
			if( actionDetails[0] == 'CREATE_ACCOUNT' ) {
				processResponse(true, 0, actionDetails[0], JSON.serialize(createAccount(reqBody)));
			} else if( actionDetails[0] == 'UPDATE_ACCOUNT' ) {
				processResponse(true, 0, actionDetails[0], JSON.serialize(updateAccount(reqBody)));
			} else {
				processResponse(false, 1006, actionDetails[0], '');
			}

		} catch(JSONException exJSON) {
			processResponse(false, 1000, null, exJSON.getMessage());
		} catch(Exception e) {
			processResponse(false, 9999, null, e.getMessage());
		}
    }

	@HttpGet
	global static void getActionRouter() {
	
		req = RestContext.request;
		resp = RestContext.response;

		try {
			actionDetails = req.requestURI.substringAfter('.do/').split('/');
			
			if( actionDetails[0] == 'GET' ) {
				processResponse(true, 0, actionDetails[0], JSON.serialize(getAccount((Id)actionDetails[1])));
			} else if( actionDetails[0] == 'GET_ALL' ) {
				processResponse(true, 0, actionDetails[0], JSON.serialize(getAllAccount()));
			}

		} catch(Exception e) {
			processResponse(false, 9999, null, e.getMessage());
		}
		
	}
    
    private static Account createAccount(Account acc) {
    	insert acc;
    	return acc;
    }
    
    private static Account updateAccount(Account acc){
    	update acc;
    	return acc;
    }

	private static Account getAccount(Id accountId) {
		System.debug('WSAccountHandler.getAccount()-- Id==>' + accountId);
		return [SELECT Id, Name, NumberOfEmployees, (SELECT Id,FirstName,LastName,Email FROM Contacts) FROM Account WHERE Id = :accountId];
	}
	
	private static List<Account> getAllAccount() {
		return [SELECT Id, Name, NumberOfEmployees, (SELECT Id,FirstName,LastName,Email FROM Contacts) FROM Account];
	}

	private static void processResponse(Boolean bolSuccess, Integer intErrorCode, String strActionName, String strDetail) {
		System.Debug('PROCESS RESPONSE - Code = ' + intErrorCode + ', Success = ' + bolSuccess + ', Message = ' + strDetail);

		resp.headers.put('Content-Type', 'application/json');
		resp.statusCode = 200;
		resp.responseBody = blob.valueOf(JSON.serialize(new WSUtil.WsResponse(bolSuccess, intErrorCode, strActionName, strDetail)));
	}
}