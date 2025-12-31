import { LightningElement,api, wire } from 'lwc';
import getContacts from '@salesforce/apex/contactContoller.getcontacts';
import { getRecord } from 'lightning/uiRecordApi';
export default class WireApexDemo extends LightningElement {
    @api recordId;
    contacts;
    error;

    @wire(getRecord, { recordId: '$recordId', fields: ['Account.Name'] })
    record;
    @wire(getContacts, {accid: '$recordId'})
    wiredContacts({error,data}){
        if(data){
            this.contacts=data;
            this.error=undefined;
        }else if(error){
            console.error=error;
            this.contacts=undefined;
        }
    }

    get name(){
        return this.record.data.fields.Name.value;
    }
}