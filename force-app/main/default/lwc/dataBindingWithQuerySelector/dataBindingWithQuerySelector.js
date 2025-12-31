import { LightningElement } from 'lwc';

export default class DataBindingWithQuerySelector extends LightningElement {
    greeting = 'sandeep'
    Firstname='';
    Lastname='';

    handleClick(event){
        const inputElements = this.template.querySelectorAll('lightning-input');
        inputElements.forEach(function(element){
            if(element.name == 'fname')
                this.Firstname = element.value;
            
            else if(element.name == 'lname')
                this.Lastname = element.value;
            }, this);
        }
  }