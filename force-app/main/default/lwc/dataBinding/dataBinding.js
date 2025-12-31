import { LightningElement } from 'lwc';


export default class DataBinding extends LightningElement {
    firstname= '';
    lastname= '';
    handleChange(event) {
        const name= event.target.name;
        if(name === 'fname'){
            this.firstname= event.target.value;
        } else if(name === 'lname'){
            this.lastname= event.target.value;
        }
    }   
    get uppercaseFullNAme(){
        return `${this.firstname.toUpperCase()} ${this.lastname.toUpperCase()}`;
    }
}