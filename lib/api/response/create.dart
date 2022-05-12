class CreateResponse {
  final String id;

  const CreateResponse({required this.id});

  factory CreateResponse.fromJson(Map<String, dynamic> json) {
    return CreateResponse(id: json['id']);
  }
}
