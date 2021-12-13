public with sharing class CTPersonController {
    public static String getToken(String mobileNo){
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);

        //get String value of the hashed blob.
        return  EncodingUtil.base64Encode(hash);
    }

    //Get 100 most recent health canged individuals.
    public static List<Person__c> GetRecentHealthChanges(){
        List<Person__c> personList = [SELECT Id,CreatedById,	Health_Status__c,LastModifiedById,Mobile__c,Name,OwnerId,Status_Update_Date__c,Token__c  FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100 ];
        return personList;
    }

    //Use a search term to return a list of people that match by either Name, Mobile number or token.
    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm = searchTerm + '%';
        List<Person__c> personList = [SELECT Id, CreatedById,	Health_Status__c,LastModifiedById,Mobile__c,Name,OwnerId,Status_Update_Date__c,Token__c  FROM Person__c WHERE (Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm ) ORDER BY  Status_Update_Date__c DESC NULLS LAST ];
        return personList;
    }
    
    //return a single person record from the database by using the PersonID as the search parameter.
    public static Person__c getPersonById(String personId){
        List<Person__c> personList = [SELECT Id, CreatedById,	Health_Status__c,LastModifiedById,Mobile__c,Name,OwnerId,Status_Update_Date__c,Token__c  FROM Person__c WHERE Id =: personId];
        if(personList.size()>0){
            return personList[0];
        }else{
            return null;
        }

    }

    public static Map<String,Integer> getHealthStatusCount(){
        Map<String,Integer> healthStatuscount = new Map<String, Integer>();

        AggregateResult[] groupedResult = [SELECT Health_Status__c, Count(Id) totalCount FROM Person__c GROUP BY Health_Status__c];

        for(AggregateResult result: groupedResult){
            String healthStatus = String.valueOf(result.get('Health_Status__c'));
            Integer healthCount = Integer.valueOf(result.get('totalCount'));
            healthStatuscount.put(healthStatus,healthCount);
        }
        return healthStatuscount;
    }

    public static Set<Id> getCohabitants(Set<Id> personIds){
        List<String> healthStatuses = new List<String>{'Green','Orange'};
       List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
       WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) AND Contact_Type__c = 'Cohabitant' AND 
       (Person_1__r.Health_Status__c IN: healthStatuses OR Person_2__r.Health_Status__c IN: healthStatuses)];

       Set<Id> cohabitants = new Set<Id>();
       for(People_Tracing__c pt: peopleTraces){
           if(!personIds.contains(pt.Person_1__c)){
               cohabitants.add(pt.Person_1__c);
           }
           if(!personIds.contains(pt.Person_2__c)){
            cohabitants.add(pt.Person_2__c);
        }

        return cohabitants;
           
       }

    }

    public static Set<Id> getNeighbours(Set<Id> personIds){
       List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
       WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) AND Contact_Type__c = 'Neighbour' AND 
       (Person_1__r.Health_Status__c  = 'Green' OR Person_2__r.Health_Status__c = 'Green')];

       Set<Id> neighbours = new Set<Id>();
       for(People_Tracing__c pt: peopleTraces){
           if(!personIds.contains(pt.Person_1__c)){
            neighbours.add(pt.Person_1__c);
           }
           if(!personIds.contains(pt.Person_2__c)){
            neighbours.add(pt.Person_2__c);
        }

        return neighbours;
           
       }

    }

    public static Set<Id> getPrimaryContacts(Set<Id> personIds){
    List<String> healthStatuses = new List<String>{'Green','Orange'};
       List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
       WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) AND 
       Contact_Type__c = 'Other' AND 
       (Person_1__r.Health_Status__c IN: healthStatuses OR Person_2__r.Health_Status__c IN: healthStatuses) AND
       Contact_Date__c = LAST_N_DAYS:10];
 
        Set<Id> contacts = new Set<Id>();
        for(People_Tracing__c pt: peopleTraces){
            if(!personIds.contains(pt.Person_1__c)){
                contacts.add(pt.Person_1__c);
            }
            if(!personIds.contains(pt.Person_2__c)){
                contacts.add(pt.Person_2__c);
         }
 
         return contacts;
            
        }
 
     }

     public static Set<Id> getSecondaryContacts(Set<Id> primaryContactIds){
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
        WHERE (Person_1__c IN :primaryContactIds OR Person_2__c IN :primaryContactIds) AND Contact_Type__c = 'Other' AND 
        (Person_1__r.Health_Status__c  = 'Green' OR Person_2__r.Health_Status__c = 'Green')
        AND Contact_Date_C = LAST_N_DAYS:10];
 
        Set<Id> secondaryContacts = new Set<Id>();
        for(People_Tracing__c pt: peopleTraces){
            if(!primaryContactIds.contains(pt.Person_1__c)){
                secondaryContacts.add(pt.Person_1__c);
            }
            if(!primaryContactIds.contains(pt.Person_2__c)){
                secondaryContacts.add(pt.Person_2__c);
         }
 
         return secondaryContacts;
            
        }
 
     }

    
}