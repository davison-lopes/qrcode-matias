class Qrcode{
   String title;
   DateTime dateTime;

   Qrcode({
      required this.title,
      required this.dateTime
});
  Qrcode.fromJson(Map<String, dynamic> json):
   title = json['title'],
   dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson(){
  return{
    'title': title,
    'dateTime':dateTime.toIso8601String()

  };
}
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }




}