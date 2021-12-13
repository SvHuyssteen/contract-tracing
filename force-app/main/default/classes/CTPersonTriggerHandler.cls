public with sharing class CTPersonTriggerHandler {
    
    public static void beforeInsert(List<Person__c> newRecords){
    
        
        for(Person__c person: newRecords){
            //update persons health status to green
            person.Health_Status__c = 'Green';
            //Generate the individuals unique token.
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }

    //Before update operation on the Person__c object.
    public static void beforeUpdate(List<Person__c> newRecords, Map<Id, Person__c> oldRecordsMap){

        for(Person__c person: newRecords){
            //Check if the status changed in this transaction
            //also update status_update_date if the status has changed.
            if(person.Health_Status__c != oldRecordsMap.get(person.Id).Health_Status__c){
                person.Status_Update_Date__c = Date.today();
            }
        }
    }

    public static void afterUpdate(List<Person__c> newRecords, Map<Id, Person__c> oldRecordsMap){

        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();
        for(Person__c person: newRecords){
            //Check if the status changed in this transaction
            //also update status_update_date if the status has changed.
            if(person.Health_Status__c != oldRecordsMap.get(person.Id).Health_Status__c){
                statusChange.add(person.Id);
                
            }

            if(person.Health_Status__c == 'Red' && oldRecordsMap.get(person.Id).Health_Status__c != 'Red'){
                redStatus.add(person.Id);
            }
        }

        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();

        //lets add cohabitants
       orangeStatus.addAll(CTPersonController.getCohabitants(redStatus));
       //lets add neighbours
       yellowStatus.addAll(CTPersonController.getNeighbours(redStatus));
       //lets add primary Contacts
       Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatus);
       orangeStatus.addAll(primaryContacts);
       //lets add secondary Contacts
       yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts));
    }
    
}
