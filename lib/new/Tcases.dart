class Tcases
{
  var cases;
  var deaths;
  var recovered;
  var updated;

  Tcases({this.cases,this.deaths,this.recovered,this.updated});



  factory Tcases.fromJson(final json)
  {
    return Tcases(

      cases:json["cases"],
      deaths : json["deaths"],
      recovered : json["recovered"],
      updated : json["updated"],
    );
  }

}
