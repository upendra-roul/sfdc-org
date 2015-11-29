global with sharing class WSUtil {

	global class WsResponse {
		global Boolean	status			{set;get;}
		global String	errorCode		{set;get;}
	    global String	message			{set;get;}
		global String	response		{set;get;}
	    global String	requestedAction	{set;get;}


		public WsResponse( Boolean passStatus, Integer passErrorCode, String passAction, String passResponseBody ){
			Map<Integer, String> mapStatusCodes = STATUS_RESTSERVICE();
			status = passStatus;
			errorCode = String.valueOf(passErrorCode);
			message = mapStatusCodes.get(passErrorCode);
			requestedAction = passAction;
			response = passResponseBody;
		}
	}

	global class WsRequest {
		global String	actionName	{set;get;}
		global Account	requestObj	{set;get;}
	}
	
	private static Map<Integer, String> STATUS_RESTSERVICE() {
        Map<Integer, String> mapStatusCodes = new Map<Integer, String>();
        mapStatusCodes.put(0, 'OPERATION_COMPLETED_SUCCESSFULLY');

        // Data and Processing Errors
        mapStatusCodes.put(1000, 'INPUT_JSON_STRUCTURE_ERROR_FOR_THIS_ACTION');
        mapStatusCodes.put(1001, 'MISSING_REQUIRED_ACTION');
        mapStatusCodes.put(1002, 'MISSING_REQUIRED_DATA');
        mapStatusCodes.put(1003, 'INVALID_ACTION');
        mapStatusCodes.put(1004, 'INVALID_OR_INCORRECTLY_STRUCTURED_REQUIRED_DATA');
        mapStatusCodes.put(1005, 'INVALID_OR_INCORRECTLY_STRUCTURED_OPTIONAL_DATA');
        mapStatusCodes.put(1006, 'ACTION_NOT_SUPPORTED');

        // Exceptions and Acts of Flying Spaghetti Monster
        mapStatusCodes.put(9999, 'CAUGHT_EXCEPTION_IN_WEBPROCESSOR_CONTACT_ADMINISTRATOR');
        return mapStatusCodes;
    }
}