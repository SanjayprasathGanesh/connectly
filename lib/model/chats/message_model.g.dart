// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Messages _$MessagesFromJson(Map<String, dynamic> json) => Messages(
      fromUserId: json['fromUserId'] as String?,
      targetUserId: json['targetUserId'] as String?,
      postMap: json['postMap'] as Map<String, dynamic>?,
      message: json['message'] as String?,
      sentTime: json['sentTime'] as String?,
    );

Map<String, dynamic> _$MessagesToJson(Messages instance) => <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'targetUserId': instance.targetUserId,
      'postMap': instance.postMap,
      'message': instance.message,
      'sentTime': instance.sentTime,
    };
