public with sharing class SobjectDetailController {
    private final static String STANDARD_PATH_PREFIX = 'standard:';
    private final static String ICON_CONTENT_TYPE = 'image/svg+xml';
    private final static String CUSTOM_PATH_PREFIX = 'custom:';
    private final static String CUSTOM_PATH_DEFAULT_PREFIX = 'custom/';
    private final static String SVG_TYPE = '.svg';

	@AuraEnabled(cacheable=true)
    public static SObjectDescribe getSObjectDescription(String sObjectName) {
        return new SObjectDescribe(Schema.describeSObjects( new List<String> { sObjectName })[0]);
    }
    
    private static List<FieldDescribe> getFieldDescribeList(Map<String, Schema.SobjectField> fieldMap) {
        List<FieldDescribe> fieldDescribeList = new List<FieldDescribe>();
        
        for(Schema.SobjectField field : fieldMap.values()) {
            fieldDescribeList.add(new FieldDescribe(field));
        }

        return fieldDescribeList;
    }

    private static String getIconPath(String sObjectName){
        String iconPath;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

        for(Schema.DescribeTabSetResult tsr : tabSetDesc) {
            tabDesc.addAll(tsr.getTabs());
        }

        for(Schema.DescribeTabResult tr : tabDesc) {
            if(sObjectName == tr.getSobjectName()) {
                if(tr.isCustom()) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    return STANDARD_PATH_PREFIX + sObjectName.toLowerCase();
                }
            }
        }

        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == ICON_CONTENT_TYPE){
                iconPath = CUSTOM_PATH_PREFIX + ir.getUrl().substringBetween(CUSTOM_PATH_DEFAULT_PREFIX, SVG_TYPE).substringBefore('_');
                break;
            }
        }

        return iconPath;
    }
    public class SObjectDescribe {
        @AuraEnabled
        public String iconPath;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String apiName;
        @AuraEnabled
        public String keyPrefix;
        @AuraEnabled
        public Boolean isAccessible;
        @AuraEnabled
        public Boolean isQueryable;
        @AuraEnabled
        public Boolean isCustom;
        @AuraEnabled
        public Boolean isUpdatable;
        @AuraEnabled
        public List<FieldDescribe> fieldDescribeList;

        public SObjectDescribe(Schema.DescribeSobjectResult sObjectDescribe) {
            this.iconPath = getIconPath(sObjectDescribe.getName());
            this.label = sObjectDescribe.getLabel();
            this.apiName = sObjectDescribe.getName();
            this.keyPrefix = sObjectDescribe.getKeyPrefix();
            this.isAccessible = sObjectDescribe.isAccessible();
            this.isQueryable = sObjectDescribe.isQueryable();
            this.isCustom = sObjectDescribe.isCustom();
            this.isUpdatable = sObjectDescribe.isUpdateable();
            this.fieldDescribeList = getFieldDescribeList(sObjectDescribe.fields.getMap());
        }
    }

    public class FieldDescribe {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public Boolean isAccessible;
        @AuraEnabled
        public Boolean isCompound;
        @AuraEnabled
        public Boolean isLookup;
        @AuraEnabled
        public String relationshipName;

        public FieldDescribe(Schema.SobjectField field) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            this.name = fieldDescribe.getName();
            this.label = fieldDescribe.getLabel();
            this.isAccessible = fieldDescribe.isAccessible();
            this.isCompound = fieldDescribe.getCompoundFieldName() != null;
            this.isLookup = fieldDescribe.isIdLookup();
            this.relationshipName = fieldDescribe.getRelationshipName();
        }
    }
}