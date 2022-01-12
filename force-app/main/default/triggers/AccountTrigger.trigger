trigger AccountTrigger on Account (before update) {
    for (Account acc: Trigger.new) {
        Account oldAcc= Trigger.oldMap.get(acc.ID);
        if (acc.BillingStreet != oldAcc.BillingStreet || acc.BillingCity != oldAcc.BillingCity || acc.BillingCountry != oldAcc.BillingCountry || acc.BillingState != oldAcc.BillingState || acc.BillingPostalCode  != oldAcc.BillingPostalCode ) {
            List<Event_for_Weather__e> addressUpdatedEvent = new List<Event_for_Weather__e>();
            addressUpdatedEvent.add(new Event_for_Weather__e(Updated__c='Yes'));
            
            
            List<Database.SaveResult> results = EventBus.publish(addressUpdatedEvent);
            
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
}