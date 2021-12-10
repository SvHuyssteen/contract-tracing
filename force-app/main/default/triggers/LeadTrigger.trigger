trigger LeadTrigger on Lead (before insert,after insert, before Update, after Update) {
    switch on Trigger.operationType{
        when BEFORE_INSERT{
			LeadTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        
        when AFTER_INSERT{
             LeadTriggerHandler.afterInsertHandler(Trigger.new);   
            
        }
        
        when BEFORE_UPDATE{
            LeadTriggerHandler.beforeUpdatetHandler(Trigger.new,Trigger.oldMap); 
        }
    }
}