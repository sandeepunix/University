import { LightningElement, api } from 'lwc';


export default class PriPubDemo extends LightningElement {
    messgae = 'Private Property in LWC';
    @api recordId;
}