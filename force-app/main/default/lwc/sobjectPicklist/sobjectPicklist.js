import { LightningElement, wire } from 'lwc';
import getSObjects from '@salesforce/apex/SobjectPicklistController.getSObjects';
import { publish, MessageContext } from 'lightning/messageService';
import itemSelect from '@salesforce/messageChannel/itemSelect__c';

export default class SobjectPicklist extends LightningElement {
    @wire(getSObjects, {})
    sObjectList;

    @wire(MessageContext)
    messageContext;

    handleChange(event) {
        const payload = { sObjectName: event.detail.value };
        publish(this.messageContext, itemSelect, payload);
    }
}