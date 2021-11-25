public with sharing class CTLocationTracingController {
    public CTLocationTracingController() {

    }

    //Returns all locationtraces from the location for which the ID was provided, ordered by visiting date and limited to 100
    public static List<Location_Tracing__c> getVisitors(String locationId){
        List<Location_Tracing__c> locationTraces    = [SELECT Id, Name, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c FROM Location_Tracing__c WHERE Id =: locationId ORDER BY Visit_Date__c LIMIT 100 ];
        return locationTraces;
    }

    //Returns all locationtraces for all the locations for whom the person Ids were privded.  This list is also ordered by visiting date and limited to visits within the last 10 days.
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        List<Location_Tracing__c> locationTraces    = [SELECT Id, Name, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c FROM Location_Tracing__c WHERE (Person__c IN: personIds AND Visit_Date__c = LAST_N_DAYS:10) ];
        return locationTraces;
    }

    //Get locationtraces by Ids of locations.  This will only return locationtraces where the persons health is Green and the location Ids are provided and the visits have been in the last 10 days.
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        List<Location_Tracing__c> locationTraces    = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE (Location__c IN: locationIds AND Person__r.Health_Status__c = 'Green' AND Visit_Date__c = LAST_N_DAYS:10) ];
        return locationTraces;
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        //Store unique location Ids
        Set<Id> locationIds = new Set<Id>();
        //Store unique person ids
        Set<Id> personIds = new Set<Id>();
        for (Location_Tracing__c trace: newLocationTraces) {
            locationIds.add(trace.Location__c);
            personIds.add(trace.Person__c);
        }

        //map of location id, set of persons ids
        Map<Id,Set<Id>> mapOfExistingRecords = new Map<Id,Set<Id>>();
        //query existing locations tracing records
        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c
        FROM Location_Tracing__c
        WHERE Location__c IN: locationIds
        AND Person__c IN: personIds];
        
        //list of duplicate records
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        if(existingRecords != null && existingRecords.size() > 0){
            for(Location_Tracing__c trace: existingRecords){
                if(!mapOfExistingRecords.containsKey(trace.Location__c)){
                    mapOfExistingRecords.put(trace.Location__c,new Set<Id>());
                }
                //add person Id to map set
                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }

            //loop over new location tracing records
            for(Location_Tracing__c trace: newLocationTraces){
                //first check for location Id
                //If item found in map, then check for person in set
                if(mapOfExistingRecords.containsKey(trace.Location__c) && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)){
                    duplicates.add(trace);
                }
            }
        }
        return duplicates;
    }


}
