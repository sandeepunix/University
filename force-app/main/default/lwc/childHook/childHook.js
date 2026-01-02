import { LightningElement } from 'lwc';

export default class ChildHook extends LightningElement {
    
    constructor() {
        super();
        console.log('Child constructor called');
    }   
    connectedCallback() {
        console.log('Child connectedCallback called');
        // Custom logic when the component is inserted into the DOM 
        throw new Error('Simulated error in Child connectedCallback');  
    }
    renderedCallback() {
        console.log('Child renderedCallback called');
    }
    disconnectedCallback() {
        console.log('Child disconnectedCallback called');
        // Custom logic when the component is removed from the DOM
    }   
    errorCallback(error, stack) {
        console.log('Child errorCallback called');
        // Custom error handling logic
    }       
    disconnectedCallback() {
        console.log('Child disconnectedCallback called');
        // Custom logic when the component is removed from the DOM
    }   

    
    
}