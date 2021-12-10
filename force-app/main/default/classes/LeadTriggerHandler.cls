public class LeadTriggerHandler {
    public static boolean alreadyExecuted = false;
    
    public static void beforeInsertHandler(List<Lead> newRecords){
        for(lead leadRecord: newRecords){
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Other';
            }
            if(String.isBlank(leadRecord.Industry)){
                leadRecord.addError('The industry can not be blank.');
            }
        }
        
    }
    
    public static void afterInsertHandler(List<Lead> newRecords){
        List<Task> leadTasks = new List<Task>();
        for(lead leadRecord: newRecords){
            //create task
            task leadTask = new Task(Subject = 'follow up on lead status',  whoId = leadRecord.Id);
            leadTasks.add(leadTask);
        }
        insert leadTasks; 
        if(leadTriggerHandler.alreadyExecuted == false){
            leadTriggerHandler.alreadyExecuted = true;
            lead anotherLead = new Lead(LastName = 'Test Lead Single', Status = 'Open - Not Contacted', Company = 'SFDCFacts', Industry = 'Finance' );
            insert anotherLead;
            
            
        }
        
        
        
    }
    
    public static void beforeUpdatetHandler(List<Lead> newRecords, Map<Id,Lead> oldRecordsMap ){
        for(lead leadRecord: newRecords){
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Other';
            }
            if((leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted') && oldRecordsMap.get(leadRecord.Id).Status == 'Open - Not Contacted'){
                leadRecord.Status.addError('You cannot directly close an open lead record.');
            }
        }
        
        
    }
    
    
}