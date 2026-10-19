import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchAccounts from '@salesforce/apex/AccountController.searchAccounts';

export default class AccountExplorer extends LightningElement {
    searchTerm = '';
    accounts = [];
    selectedName;

    handleChange(event) {
        this.searchTerm = event.target.value;
    }

    async handleSearch() {
        this.selectedName = undefined;
        try {
            this.accounts = await searchAccounts({ searchTerm: this.searchTerm });
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

    handleAccountSelect(event) {
        this.selectedName = event.detail.accountName;
    }
}