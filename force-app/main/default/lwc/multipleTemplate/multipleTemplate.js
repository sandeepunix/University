import { LightningElement } from 'lwc';
import templateA from './TemplateA.html';
import templateB from './TemplateB.html';
export default class MultipleTemplate extends LightningElement {
    templateA = true;
    render() {
        return this.templateA ? templateA : templateB;
    }

    changeTemplate() {
        this.templateA = !this.templateA === true ? true : false;
    }
    }