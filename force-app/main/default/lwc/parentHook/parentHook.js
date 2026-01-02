import { LightningElement } from 'lwc';

export default class Parenthook extends LightningElement {
    displayChild = false;
    constructor() {
        super();
        console.log('Parent constructor called');
    }   
    connectedCallback() {
        console.log('Parent connectedCallback called');
        // Custom logic when the component is inserted into the DOM 
    }
    renderedCallback() {
        console.log('Parent renderedCallback called');
        // Custom logic after the component has been rendered
    }
    disconnectedCallback() {
        console.log('Parent disconnectedCallback called');
        // Custom logic when the component is removed from the DOM
    }   
    errorCallback(error, stack) {
        console.log('Parent errorCallback called');
        console.log('Error: ' + error);
        console.log('Stack: ' + stack);
        // Custom error handling logic
    }   
    disconnectedCallback() {
        console.log('Parent disconnectedCallback called');
        // Custom logic when the component is removed from the DOM
    }
        changehandler(event) {
        this.displayChild = event.target.checked;
    }
}