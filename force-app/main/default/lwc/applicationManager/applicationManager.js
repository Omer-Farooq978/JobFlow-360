import { LightningElement, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getApplications from '@salesforce/apex/JobApplicationLwcController.getApplications';

export default class ApplicationManager extends LightningElement {
    
    searchTerm = '';
    selectedStatus = 'All';
    pendingStatusChanges = [];
    statusOptions = [
    { label: 'All Statuses', value: 'All' },
    { label: 'Saved', value: 'Saved' },
    { label: 'Applied', value: 'Applied' },
    { label: 'Screening', value: 'Screening' },
    { label: 'Interview', value: 'Interview' },
    { label: 'Offer', value: 'Offer' },
    { label: 'Rejected', value: 'Rejected' },
    { label: 'Withdrawn', value: 'Withdrawn' }
];

applicationStatusOptions = [
    { label: 'Saved', value: 'Saved' },
    { label: 'Applied', value: 'Applied' },
    { label: 'Screening', value: 'Screening' },
    { label: 'Interview', value: 'Interview' },
    { label: 'Offer', value: 'Offer' },
    { label: 'Rejected', value: 'Rejected' },
    { label: 'Withdrawn', value: 'Withdrawn' }
];

    @wire(getApplications)
    applications;

   

get filteredApplications() {
    if (!this.applications.data) {
        return [];
    }

    const searchKey = this.searchTerm.toLowerCase();

    return this.applications.data
        .filter(app => {
            const matchesName = app.Name.toLowerCase().includes(searchKey);

            const matchesStatus =
                this.selectedStatus === 'All' ||
                app.Application_Status__c === this.selectedStatus;

            return matchesName && matchesStatus;
        })
        .map(app => {
            const pendingChange = this.pendingStatusChanges.find(
                change => change.recordId === app.Id
            );

            return {
                ...app,
                selectedStatus: pendingChange
                    ? pendingChange.status
                    : app.Application_Status__c
            };
        });
}

handleSearch(event) {
    this.searchTerm = event.target.value;
}
handleStatusChange(event) {
    this.selectedStatus = event.detail.value;
}

handleRowStatusChange(event) {
    const recordId = event.target.dataset.id;
    const newStatus = event.detail.value;

    const application = this.applications.data.find(
        app => app.Id === recordId
    );

    if (!application) {
        return;
    }

    if (newStatus === application.Application_Status__c) {
        this.pendingStatusChanges =
            this.pendingStatusChanges.filter(
                change => change.recordId !== recordId
            );
        return;
    }

    this.pendingStatusChanges = [
        ...this.pendingStatusChanges.filter(
            change => change.recordId !== recordId
        ),
        {
            recordId: recordId,
            status: newStatus
        }
    ];
}

handleSaveStatus(event) {
    const recordId = event.currentTarget.dataset.id;

    const pendingChange = this.pendingStatusChanges.find(
        change => change.recordId === recordId
    );

    if (!pendingChange) {
        return;
    }

    const fields = {
        Id: recordId,
        Application_Status__c: pendingChange.status
    };

    const recordInput = { fields };

    updateRecord(recordInput)
        .then(() => refreshApex(this.applications))
        .then(() => {
            this.pendingStatusChanges =
                this.pendingStatusChanges.filter(
                    change => change.recordId !== recordId
                );

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Application status updated successfully.',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            console.error('Error updating status:', error);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Unable to update application status. Please try again.',
                    variant: 'error'
                })
            );
        });
}


}
