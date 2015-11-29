public with sharing class AdditonalRevenueControllerExtn {

        public String reasonForDelete{set;get;}
        public boolean isSuccess = false;
        public AdditonalRevenue__c obj {get; set;}

        public AdditonalRevenueControllerExtn(ApexPages.StandardController controller) {
                obj = (AdditonalRevenue__c)controller.getRecord();
        }

		public PageReference doDelete(){

			try {
				AdditonalRevenue__c ar = [select Id, Description__c, TopUpAmount__c, Opportunity__c from AdditonalRevenue__c where Id = :obj.Id];
				delete ar;
				//sendEmailToAddnlRevDeleteQueue('upendraroul@yahoo.in', getEmailSubject(), getEmailBody(reasonForDelete, ar) );
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Record deleted successfully!'));
				isSuccess = true;
			} catch(Exception e) {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
				System.debug('AdditonalRevenueControllerExtn ==>' + e.getMessage());
			}
			return null;
		}


        public void setIsSuccess(boolean isSuccess) {
                this.isSuccess = isSuccess;
        }

        public boolean getIsSuccess() {
                return isSuccess;
        }


        public EmailTemplate getEmailTemplateFromTemplateName(String templateName) {
                EmailTemplate eTemplate = [select Id,Name,Subject,body from EmailTemplate where name = :templateName];
                return eTemplate;
        }


        public void sendEmailToAddnlRevDeleteQueue(String toAddress, String subject, String body) {
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();

                sendTo.add(toAddress);
                mail.setToAddresses(sendTo);
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                mails.add(mail);
                Messaging.sendEmail(mails);
        }

        private String getEmailBody(String reasonForDelete, AdditonalRevenue__c ar) {
                String returnBody = '<p>Hi All, </p>' +
                                                        '<p>Following Additional Revenue has been deleted. </p>' +
                                                        'Description: '+ ar.Description__c + '<br/>' +
                                                        'Opportunity: '+ ar.Opportunity__c + '<br/>' +
                                                        'Amount: '+ ar.TopUpAmount__c + '<br/>' +
                                                        'Description: '+ reasonForDelete +
                                                        '<p> Thanks!</p>';
                return returnBody;
        }

        private String getEmailSubject() {
                String returnSubject = 'Additional Revenue record has been deleted';
                return returnSubject;
        }
}