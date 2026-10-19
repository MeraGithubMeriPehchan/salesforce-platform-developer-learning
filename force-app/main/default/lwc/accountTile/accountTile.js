import { LightningElement, api } from 'lwc';

export default class AccountTile extends LightningElement {
    @api account;

    get industry() {
        return this.account && this.account.Industry ? this.account.Industry : 'n/a';
    }

    get rating() {
        return this.account && this.account.Rating ? this.account.Rating : 'n/a';
    }

    handleSelect() {
        this.dispatchEvent(
            new CustomEvent('accountselect', {
                detail: {
                    accountId: this.account.Id,
                    accountName: this.account.Name
                }
            })
        );
    }
}