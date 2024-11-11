import 'package:json_annotation/json_annotation.dart';
part 'posts_model.g.dart';

@JsonSerializable()
class Posts {
  String? userId;
  String? postedDate;
  String? postType;
  String? description;
  String? location;
  bool? isLiked;
  List<String>? imageUrl;
  List<String>? likedByList;
  List<Map<String, String>?> commentsList;

  Posts({
    required this.userId,
    required this.postedDate,
    required this.postType,
    required this.description,
    required this.location,
    required this.isLiked,
    required this.imageUrl,
    required this.likedByList,
    required this.commentsList,
  });

  // De-serialization
  factory Posts.fromJson(Map<String, dynamic> json) => _$PostsFromJson(json);

  // Serialization
  Map<String, dynamic> toJson() => _$PostsToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Posts &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              postedDate == other.postedDate &&
              postType == other.postType &&
              description == other.description &&
              location == other.location &&
              isLiked == other.isLiked &&
              _deepListEqual(imageUrl, other.imageUrl) &&
              _deepListEqual(likedByList, other.likedByList) &&
              commentsList == other.commentsList);

  @override
  int get hashCode =>
      userId.hashCode ^
      postedDate.hashCode ^
      postType.hashCode ^
      description.hashCode ^
      location.hashCode ^
      isLiked.hashCode ^
      _listHashCode(imageUrl) ^
      _listHashCode(likedByList) ^
      commentsList.hashCode;

  // Helper method to compare lists element by element
  bool _deepListEqual(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  // Helper method to get a hash code for lists
  int _listHashCode(List<String>? list) {
    if (list == null) return 0;
    return list.fold(0, (prev, element) => prev ^ element.hashCode);
  }
}
