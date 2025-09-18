import 'dart:convert';

class YouTubePostData {
  String getYouTubePostData() {
    return '''
    [
    {
      'title' : "abcd",
      'description' :"abcd"
    },
     {
      'title' : "efgh",
      'description' :"efgh"
    }
    ]
  ''';
  }
}

class TwitterPostData {
  String getTwitterPostData() {
    return '''
    [
    {
      'name' : "abcd",
      'bio' :"abcd"
    },
     {
      'name' : "efgh",
      'bio' :"efgh"
    }
    ]
  ''';
  }
}

abstract class IPostAPI {
  List<Post> getPostData();
}

class Post {
  final String title;
  final String bio;
  const Post({required this.bio, required this.title});
}

class PostAPI1Adapter implements IPostAPI {
  final YouTubePostData youTubePostData;

  const PostAPI1Adapter({required this.youTubePostData});

  @override
  List<Post> getPostData() {
    final data = jsonDecode(youTubePostData.getYouTubePostData()) as List;
    return data.map((postData) {
      return Post(bio: postData["description"], title: postData["title"]);
    }).toList();
  }
}

class PostAPI2Adapter implements IPostAPI {
  final TwitterPostData twitterPostData;

  const PostAPI2Adapter({required this.twitterPostData});
  @override
  List<Post> getPostData() {
    final data = jsonDecode(twitterPostData.getTwitterPostData()) as List;
    return data.map((postData) {
      return Post(bio: postData["bio"], title: postData["name"]);
    }).toList();
  }
}

class PostAPIConnector extends IPostAPI {
  final PostAPI2Adapter twitterPostData;
  final PostAPI1Adapter youTubePostData;

  PostAPIConnector(
      {required this.twitterPostData, required this.youTubePostData});

  @override
  List<Post> getPostData() {
    return twitterPostData.getPostData() + youTubePostData.getPostData();
  }
}
