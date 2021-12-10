trigger LeadTrigger2 on Lead (before insert, before Update) {
    
    for(Lead leadRecord: Trigger.new){
        if(String.isBlank(leadRecord.Rating)){
            leadRecord.Rating = 'Warm';
        }
    }
    
    System.debug('Lead Trigger 2 is executing');

}