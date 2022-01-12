public with sharing class getWeatherCallout {

    public HttpResponse getLatLong(String lat, String lon) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://api.openweathermap.org/data/2.5/onecall?lat='+ lat + '&lon=' + lon + '&appid=a732cbd72fe7f4189adabdf666f45cbe');   
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        return res;
    }
}