import 'package:connectly/model/posts/posts_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'message_model.g.dart';

@JsonSerializable()
class Messages{
  String? fromUserId;
  String? targetUserId;
  Map<String,dynamic>? postMap;
  String? message;
  String? sentTime;

  Messages({
    required this.fromUserId,
    required this.targetUserId,
    required this.postMap,
    required this.message,
    required this.sentTime
  });

  factory Messages.fromJson(Map<String, dynamic> json) => _$MessagesFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesToJson(this);
}