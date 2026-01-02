import { LightningElement } from 'lwc';

export default class ConditionalRendering extends LightningElement {
showDetails = false;
handleCheckboxChange(event){
    this.showDetails = event.target.checked;
}
}