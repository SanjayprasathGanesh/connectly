// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Posts _$PostsFromJson(Map<String, dynamic> json) => Posts(
      userId: json['userId'] as String?,
      postedDate: json['postedDate'] as String?,
      postType: json['postType'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      isLiked: json['isLiked'] as bool?,
      imageUrl: (json['imageUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      likedByList: (json['likedByList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      commentsList: (json['commentsList'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ))
          .toList(),
    );

Map<String, dynamic> _$PostsToJson(Posts instance) => <String, dynamic>{
      'userId': instance.userId,
      'postedDate': instance.postedDate,
      'postType': instance.postType,
      'description': instance.description,
      'location': instance.location,
      'isLiked': instance.isLiked,
      'imageUrl': instance.imageUrl,
      'likedByList': instance.likedByList,
      'commentsList': instance.commentsList,
    };
