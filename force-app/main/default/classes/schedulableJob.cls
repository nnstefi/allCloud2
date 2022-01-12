public with sharing class schedulableJob implements Schedulable {
    public void execute(SchedulableContext SC) {
        batchJob myBatch = new batchJob();
        Id batchinstanceid = database.executeBatch(myBatch); 
    }
 }