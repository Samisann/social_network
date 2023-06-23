class Token{
  String accessToken;
  Token(this.accessToken);
  factory Token.fromJson(dynamic json) {
    return Token(json['access_token'] as String);
  }
}