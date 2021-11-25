public with sharing class CTPeopleTracingController {
    public CTPeopleTracingController() {

    }

    public static List<People_Tracing__c> getTrace(String recordId){
        List<People_Tracing__c> peopleTracingList = [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c,
         Person_2__c, Person_2__r.Health_Status__c, Person_2__r.Token__c FROM People_Tracing__c 
         WHERE Person_1__c =: recordId OR Person_2__c =: recordId
          ORDER BY Contact_Date__c DESC];

        return peopleTracingList;

    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTrace){
        //initialize all unique IDs in for Person 1 and person 2
        Set<Id> person1Set = new Set<Id>();
        Set<Id> person2Set = new Set<Id>();

        //initalize duplicate list
        List<People_Tracing__c> duplicatesList = new List<People_Tracing__c>();

        //initialize map of ID person 1 which will have a set of Ids for person 2
        Map<Id,Set<Id>> mapOfExistingRecords = new Map<Id,Set<Id>>();

        //get all unique IDs in for Person 1 and person 2
        for(People_Tracing__c trace : peopleTrace){
            person1Set.add(trace.Person_1__c);
            person2Set.add(trace.Person_2__c);
        }
        
        //Query database to return all traces where either individual 1 or 2 is found.
        List<People_Tracing__c> traceDataList = [SELECT Person_1__c, Person_2__c FROM People_Tracing__c
         WHERE (Person_1__c IN: person1Set OR Person_2__c IN: person2Set)];


         //Sort the traceDatalist into a map containing an ID of person 1 and a set of Ids for person 2.  This will ensure the Map will capture all unique interactions between
         //Person 1 and all other Person 2 interactions.  The vise versa will be done for person 2
         if(traceDataList != null && traceDataList.size() > 0){
             //iterate through date received from database
            for(People_Tracing__c trace : traceDataList){
                //create Map of all Ids on Person 1 that are unique and intialize a set for them as a value that will contain the Ids of person 2
                if(!mapOfExistingRecords.containsKey(trace.Person_1__c)){
                    mapOfExistingRecords.put(trace.Person_1__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

                if(!mapOfExistingRecords.containsKey(trace.Person_2__c)){
                    mapOfExistingRecords.put(trace.Person_2__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
            }
         }

         //loop over list sent through to method and check if the unique combo of Person1 Id and Person2 Id is contained within the mapOfExistingRecords.
         for(People_Tracing__c trace : peopleTrace){
             if((mapOfExistingRecords.containsKey(trace.Person_1__c) && mapOfExistingRecords.get(trace.Person_1__c).contains(trace.Person_2__c))
             || (mapOfExistingRecords.containsKey(trace.Person_2__c) && mapOfExistingRecords.get(trace.Person_2__c).contains(trace.Person_1__c)) ){
                 duplicatesList.add(trace);
             }
         }
         return duplicatesList;
    }



    


}
