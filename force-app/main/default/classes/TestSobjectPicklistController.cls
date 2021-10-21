@isTest
public with sharing class TestSobjectPicklistController {
    @isTest 
    static void testGetSObjects() {
        System.assertNotEquals(null, SobjectPicklistController.getSObjects());
    }
}
