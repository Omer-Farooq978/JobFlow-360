
import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getApplications from '@salesforce/apex/JobApplicationLwcController.getApplications';

export default class JobFlowDashboard extends LightningElement {
    applications;
    error;
    loading = true;
    wiredApplicationsResult;

    @wire(getApplications)
    wiredApplications(result) {
        this.wiredApplicationsResult = result;

        const { data, error } = result;

        if (data) {
            this.applications = data;
            this.error = undefined;
            this.loading = false;
        } else if (error) {
            this.error = error;
            this.applications = undefined;
            this.loading = false;
        }
    }

    async handleRefresh() {
        this.loading = true;

        try {
            await refreshApex(this.wiredApplicationsResult);
        } finally {
            this.loading = false;
        }
    }

    get totalApplications() {
        return this.applications?.length || 0;
    }

    countByStatus(status) {
        return (this.applications || []).filter(
            app => app.Application_Status__c === status
        ).length;
    }

    get offerCount() {
        return this.countByStatus('Offer');
    }

    get interviewCount() {
        return this.countByStatus('Interview');
    }

    get inProgressCount() {
        return this.countByStatus('Applied') +
            this.countByStatus('Screening');
    }

    get overdueApplications() {
        const today = new Date();
        const todayString = [
            today.getFullYear(),
            String(today.getMonth() + 1).padStart(2, '0'),
            String(today.getDate()).padStart(2, '0')
        ].join('-');

        return (this.applications || []).filter(app =>
            app.Follow_up_Date__c &&
            app.Follow_up_Date__c < todayString &&
            !['Rejected', 'Withdrawn'].includes(
                app.Application_Status__c
            )
        );
    }

    get overdueCount() {
        return this.overdueApplications.length;
    }

    get statusStats() {
        const statuses = [
            'Applied',
            'Screening',
            'Interview',
            'Offer',
            'Rejected',
            'Withdrawn'
        ];

        return statuses.map(status => {
            const count = this.countByStatus(status);
            const width = this.totalApplications
                ? (count / this.totalApplications) * 100
                : 0;

            return {
                label: status,
                count,
                style: `width: ${width}%`
            };
        });
    }
}
