public with sharing class SobjectPicklistController {
    
    @AuraEnabled(cacheable=true)
    public static List<PicklistOption> getSObjects() {
        List<PicklistOption> picklistOptionList = new List<PicklistOption>();
        Map<String, SObjectType> sObjects = Schema.getGlobalDescribe();
        for (String apiName : sObjects.keySet()) {
            picklistOptionList.add(new PicklistOption(apiName, sObjects.get(apiName).getDescribe().getLabel()));
        }
        picklistOptionList.sort();
        return picklistOptionList;
    }

    public class PicklistOption implements Comparable {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;

        public PicklistOption(String value, String label) {
            this.label = label;
            this.value = value;
        }
        public Integer compareTo(Object compareTo) {
            PicklistOption compareToOpt = (PicklistOption)compareTo;
            if (label == compareToOpt.label) return 0;
            if (label > compareToOpt.label) return 1;
            return -1;
        }
    }
}
