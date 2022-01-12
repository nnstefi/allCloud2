import { LightningElement, api, track } from 'lwc';
import { subscribe, onError }  from 'lightning/empApi';
import getAddress from '@salesforce/apex/getWeather.getAddress';
import getLatLog from '@salesforce/apex/getWeather.getLatLog';
import getWeather from '@salesforce/apex/getWeather.getWeather';

export default class WeatherCmp extends LightningElement {
    @api record;
    @track address;
    @track weather;
    @track latLongMap;
    @track latitude;
    @track longitude;
    @track weatherValue;
    subscription = {};
    @api channelName = '/event/Event_for_Weather__e';
    @track billingAddressUpdated;
    receivedMessage;

    connectedCallback(){
        this.recordId = this.record;
        this.getAddress(); 

        this.registerErrorListener();
        this.handleSubscribe();

    }

    handleSubscribe() {
        const messageCallback = (response) => {
            this.handleResponse(response);
        }
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });
 
         
    }
 
    handleResponse(response){
        if(response.data.payload.Updated__c){
            this.receivedMessage = response.data.payload.Updated__c;
            this.recordId = this.record;
        }
        if(response.data.payload.Id__c){
            this.idFromEvent = response.data.payload.Id__c;
            if(response.data.payload.Id__c == this.record){
                this.recordId = response.data.payload.Id__c;
            }
        }
        
            //refresh component 
            this.getAddress();
    } 

    registerErrorListener() {
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }

    getAddress(){
        getAddress({recordId: this.recordId})
            .then(result => {
                this.address = result;
            })
            .catch(error => {
                console.log('error address' + JSON.stringify(error));
                this.address = 'Error retrieving the data';
            })  
            this.getLatLog(); 
    }

    getLatLog(){
        getLatLog({recordId: this.recordId})
            .then(result => {
                this.latLongMap = result;
                this.latitude = this.latLongMap.lat;
                this.longitude = this.latLongMap.long;
                getWeather({latitude: this.latitude, longitude: this.longitude})
                    .then(result => {
                        this.weather = JSON.parse(result);
                        this.weatherValue = this.weather.current.weather[0].description;
                    })
                    .catch(error => {
                        console.log('error weather' + JSON.stringify(error));
                        this.weatherValue = 'Error retrieving the data';
                    })
            })
            .catch(error => {
                console.log('error lat long' + JSON.stringify(error));
                this.weatherValue = 'Error retrieving the data';
            })
    }
}