public class batchJob implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {

        String query = 'SELECT Id, BillingStreet FROM Account';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope){
        List<Id> idList = new List<Id>();

        for (Account acc: scope){
            
            idList.add(acc.Id);
        }

        for(Integer i = 0; i < idList.size(); i++){
            system.debug(idList[i]);
            List<Event_for_Weather__e> addressIdUpdatedEvent = new List<Event_for_Weather__e>();
            addressIdUpdatedEvent.add(new Event_for_Weather__e(Id__c=idList[i]));
                
                
            List<Database.SaveResult> results = EventBus.publish(addressIdUpdatedEvent);
            
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                    }
                }       
            }
        }    
    }    

    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    
}