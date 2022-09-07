// ignore_for_file: non_constant_identifier_names

class Success{
  bool? Status;
  String? message;
  Object? data;
  Success({this.Status,this.message,this.data});
}


class Failure{
  bool? Status;
  String? message;
  Object? data;
  Failure({this.Status,this.message,this.data});
}


 Future<Map<String, dynamic>> failure(bool Status,String message) async{
 var result = {'status': Status, 'message': message,} ;
 return result;
}

Future<Map<String, dynamic>> success(bool Status,String message, {Object? data}) async{
  var result = {'status': Status, 'message': message,'data':data} ;
  return result;
}