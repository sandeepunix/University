
import { LightningElement, api } from 'lwc';
import getcontacts from '@salesforce/apex/ContactController.getcontacts';

export default class RenderingListForEach extends LightningElement {
    @api recordId;

        contacts = [{
        id: '1',
        name: 'John Doe',
        title: 'CEO'
    },
    {
        id: '2',
        name: 'Jane Smith',
        title: 'CTO'
    },
    {
        id: '3',
        name: 'Emily Johnson',
        title: 'CFO'    
    },
    {
        id: '4',
        name: 'Michael Brown',
        title: 'CIO'
    },];
}