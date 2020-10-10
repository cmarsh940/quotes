class Quote {
  String message;
  String person;

  Quote({this.message, this.person});

  Quote.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    person = json['person'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['person'] = this.person;
    return data;
  }
}