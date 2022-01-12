public with sharing class getWeather {
    @AuraEnabled
    public static string getAddress(String recordId){
        String addressValue;
        try {
            List<Account> acc = [SELECT BillingAddress FROM Account WHERE Id = :recordId];
            System.address address =  acc[0].BillingAddress;
            addressValue = address.getStreet() + ' ' + address.getCity() + ' ' + address.getState() + ' ' + address.getPostalCode() + ' ' + address.getCountry();
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return addressValue;
    }

    @AuraEnabled
    public static Map<String, Double> getLatLog(String recordId){
        Map<String, Double> latLongMap = new Map<String, Double>();
        try {
            List<Account> acc = [SELECT BillingAddress FROM Account WHERE Id = :recordId];
            System.address address =  acc[0].BillingAddress;
            system.debug('address => ' + address);
            double lat = address.getLatitude();
            double longitude = address.getLongitude();
            latLongMap.put('lat', lat);
            latLongMap.put('long', longitude);

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return latLongMap;
    }

    @AuraEnabled
    public static String getWeather(Double latitude, Double longitude){
        String lat = string.valueof(latitude);
        String lon = string.valueof(longitude);
        String result;
        try {
            result = getWeatherCallout(lat, lon);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return result;
    }

    @AuraEnabled
    public static String getWeatherCallout(String lat, String lon) {
        
        HttpResponse res = new HttpResponse(); 
        getWeatherCallout ac = new getWeatherCallout();
        res = ac.getLatLong(lat, lon);
        return res.getBody();
    }
}