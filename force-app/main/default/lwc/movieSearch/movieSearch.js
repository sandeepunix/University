import { LightningElement } from 'lwc';

export default class MovieSearch extends LightningElement {
    DELAY = 300;
    selectedType = '';
    selectedSearch = '';
    loading = false;  
    selectedPageNo = 1;  
    delayTimeout;
        get typeOptions() {
            return [
                { label: 'None', value: '' },
                { label: 'Movie', value: 'movie' },
                { label: 'Series Progress', value: 'series' },
                { label: 'Episode', value: 'episode' }
            ];
      }
      handleChange(event){
        console.log('Event Target Name-->',event.target.name);
            let {name, value} = event.target;
            this.loading = true;
            if(name === 'type'){
                  this.selectedType = value;
            }
            else if(name === "search"){
                console.log('Search Value-->',value);   
                this.selectedSearch = value;
                console.log('Selected Search-->',this.selectedSearch);
            }
            else if(name === "pageno"){
                this.selectedPageNo = value;
            }
            clearTimeout(this.delayTimeout);
            this.delayTimeout = setTimeout(() => {
                console.log('Selected Type-->',"display in timeout");
                    this.searchMovies();
                    }, DELAY);
            
        }
    async searchMovies(){
        
        const url = `https://www.omdbapi.com/?s=${this.selectedSearch}&type=${this.selectedType}&page=${this.selectedPageNo}&apikey=da705512`;
        console.log('URL-->',url);
        const res = await fetch(url);
        const data = await res.json();
        console.log("Movie Search Output",data);
       
    }
}