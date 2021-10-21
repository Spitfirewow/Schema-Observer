import { LightningElement, wire } from "lwc";
import getSObjectDescription from '@salesforce/apex/SobjectDetailController.getSObjectDescription';
import {
    subscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import itemSelect from '@salesforce/messageChannel/itemSelect__c';


export default class SObjectInformation extends LightningElement {
    columns = [
        { label: 'Name', fieldName: 'name' },
        { label: 'Label', fieldName: 'label'},
        { label: 'Is Accessible', fieldName: 'isAccessible'},
        { label: 'Is Compound', fieldName: 'isCompound'},
        { label: 'Is Lookup', fieldName: 'isLookup'},
        { label: 'Relationship Name', fieldName: 'relationshipName'},
    ];

    @wire(getSObjectDescription, { sObjectName: '$sObjectName' })
    sObjectDescription;

    @wire(MessageContext)
    messageContext;

    sObjectName;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                itemSelect,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }
    handleMessage(message) {
        this.sObjectName = message.sObjectName;
    }
}