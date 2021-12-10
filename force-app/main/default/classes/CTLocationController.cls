public with sharing class CTLocationController {
    public CTLocationController() {

    }

    //return 100 locations ordered by most recent status updates.
    public static List<Location__c>  getRecentStatusChanges(){
        List<Location__c> locations = [SELECT Status__c, Status_Update_Date__c, Red_Score__c, Pincode__c, Address__c, Name, Id FROM Location__c ORDER BY Status_Update_date__c DESC NULLS LAST LIMIT 100];
        return locations;
    }
    // returns locations that match the search term.  the fields searcehd are Name, pincode and address.
    public static List<Location__c> searchLocations(String searchTerm){
        //prep searchterm to have a wildcard for the LIKE search type.
        searchTerm = searchTerm + '%';
        
        List<Location__c> locations = [SELECT Status__c, Status_Update_Date__c, Red_Score__c, Pincode__c, Address__c, Name, Id FROM Location__c WHERE (Name LIKE: searchTerm OR Pincode__c LIKE: searchTerm OR Address__c LIKE: searchTerm) ORDER BY Status_Update_date__c DESC NULLS LAST LIMIT 100];
        return locations;
    }
    //returns a single location by locationID search
    public static Location__c getLocationById(String locationId){
        List<Location__c> locations =  [SELECT Status__c, Status_Update_Date__c, Red_Score__c, Pincode__c, Address__c, Name, Id FROM Location__c WHERE Id =: locationId];

        //check if there is some values returned in the list of locations
        if(locations.size() <= 0){
            //if not return null
            return null;
        }else{
            //if there is values return the first one.
            return locations[0];
        }

    }
}