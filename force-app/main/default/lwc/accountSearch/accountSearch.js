import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchAccounts from '@salesforce/apex/AccountController.searchAccounts';

export default class AccountSearch extends LightningElement {
    searchTerm = '';
    accounts = [];
    searched = false;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Industry', fieldName: 'Industry' },
        { label: 'Rating', fieldName: 'Rating' }
    ];

    handleChange(event) {
        this.searchTerm = event.target.value;
    }

    async handleSearch() {
        try {
            this.accounts = await searchAccounts({ searchTerm: this.searchTerm });
            this.searched = true;
        } catch (error) {
            this.accounts = [];
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Search failed',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error'
                })
            );
        }
    }

    get hasResults() {
        return this.accounts.length > 0;
    }

    get noResults() {
        return this.searched && this.accounts.length === 0;
    }
}