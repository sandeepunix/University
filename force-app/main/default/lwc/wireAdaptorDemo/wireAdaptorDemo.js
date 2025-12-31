import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi'; 
//import NAME_FIELD from '@salesforce/schema/Account.Name';
//import PHONE_FIELD from '@salesforce/schema/Account.Phone';
const FIELDS = ['Account.Name', 'Account.Phone'];
export default class WireAdaptorDemo extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    record;
    
    get name() {
        //return this.record.data ? getFieldValue(this.record.data, 'Account.Name') : null;
        return this.record.data.fields.Name.value;
    }
    get phone() {
        //return this.record.data ? getFieldValue(this.record.data, 'Account.Phone') : null;
        return this.record.data.fields.Phone.value;
    }
}