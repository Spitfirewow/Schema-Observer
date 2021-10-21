@isTest 
public with sharing class TestSobjectDetailController {
    private final static String CONTACT_API_NAME = 'Contact';
    @isTest 
    static void getSObjectListTest() {
        System.assertEquals(SobjectDetailController.getSObjectDescription(CONTACT_API_NAME).apiName, CONTACT_API_NAME);
    }
}
