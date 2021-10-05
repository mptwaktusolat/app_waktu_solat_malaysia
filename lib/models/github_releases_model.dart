// Only cares about the tag name

class GithubReleasesModel {
  // String? url;
  // String? assetsUrl;
  // String? uploadUrl;
  // String? htmlUrl;
  // int? id;
  // Author? author;
  // String? nodeId;
  String? tagName;
  // String? targetCommitish;
  // String? name;
  // bool? draft;
  // bool? prerelease;
  // String? createdAt;
  // String? publishedAt;
  // List<dynamic>? assets;
  // String? tarballUrl;
  // String? zipballUrl;
  // String? body;

  GithubReleasesModel({
    // this.url,
    // this.assetsUrl,
    // this.uploadUrl,
    // this.htmlUrl,
    // this.id,
    // this.author,
    // this.nodeId,
    this.tagName,
    // this.targetCommitish,
    // this.name,
    // this.draft,
    // this.prerelease,
    // this.createdAt,
    // this.publishedAt,
    // this.assets,
    // this.tarballUrl,
    // this.zipballUrl,
    // this.body,
  });

  GithubReleasesModel.fromJson(Map<String, dynamic> json) {
    // this.url = json["url"];
    // this.assetsUrl = json["assets_url"];
    // this.uploadUrl = json["upload_url"];
    // this.htmlUrl = json["html_url"];
    // this.id = json["id"];
    // this.author = json["author"] == null ? null : Author.fromJson(json["author"]);
    // this.nodeId = json["node_id"];
    tagName = json["tag_name"];
    // this.targetCommitish = json["target_commitish"];
    // this.name = json["name"];
    // this.draft = json["draft"];
    // this.prerelease = json["prerelease"];
    // this.createdAt = json["created_at"];
    // this.publishedAt = json["published_at"];
    // this.assets = json["assets"] ?? [];
    // this.tarballUrl = json["tarball_url"];
    // this.zipballUrl = json["zipball_url"];
    // this.body = json["body"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data["url"] = this.url;
    // data["assets_url"] = this.assetsUrl;
    // data["upload_url"] = this.uploadUrl;
    // data["html_url"] = this.htmlUrl;
    // data["id"] = this.id;
    // if(this.author != null)
    //     data["author"] = this.author?.toJson();
    // data["node_id"] = this.nodeId;
    data["tag_name"] = tagName;
    // data["target_commitish"] = this.targetCommitish;
    // data["name"] = this.name;
    // data["draft"] = this.draft;
    // data["prerelease"] = this.prerelease;
    // data["created_at"] = this.createdAt;
    // data["published_at"] = this.publishedAt;
    // if(this.assets != null)
    //     data["assets"] = this.assets;
    // data["tarball_url"] = this.tarballUrl;
    // data["zipball_url"] = this.zipballUrl;
    // data["body"] = this.body;
    return data;
  }
}

// class Author {
//   String? login;
//   int? id;
//   String? nodeId;
//   String? avatarUrl;
//   String? gravatarId;
//   String? url;
//   String? htmlUrl;
//   String? followersUrl;
//   String? followingUrl;
//   String? gistsUrl;
//   String? starredUrl;
//   String? subscriptionsUrl;
//   String? organizationsUrl;
//   String? reposUrl;
//   String? eventsUrl;
//   String? receivedEventsUrl;
//   String? type;
//   bool? siteAdmin;

//   Author(
//       {this.login,
//       this.id,
//       this.nodeId,
//       this.avatarUrl,
//       this.gravatarId,
//       this.url,
//       this.htmlUrl,
//       this.followersUrl,
//       this.followingUrl,
//       this.gistsUrl,
//       this.starredUrl,
//       this.subscriptionsUrl,
//       this.organizationsUrl,
//       this.reposUrl,
//       this.eventsUrl,
//       this.receivedEventsUrl,
//       this.type,
//       this.siteAdmin});

//   Author.fromJson(Map<String, dynamic> json) {
//     login = json["login"];
//     id = json["id"];
//     nodeId = json["node_id"];
//     avatarUrl = json["avatar_url"];
//     gravatarId = json["gravatar_id"];
//     url = json["url"];
//     htmlUrl = json["html_url"];
//     followersUrl = json["followers_url"];
//     followingUrl = json["following_url"];
//     gistsUrl = json["gists_url"];
//     starredUrl = json["starred_url"];
//     subscriptionsUrl = json["subscriptions_url"];
//     organizationsUrl = json["organizations_url"];
//     reposUrl = json["repos_url"];
//     eventsUrl = json["events_url"];
//     receivedEventsUrl = json["received_events_url"];
//     type = json["type"];
//     siteAdmin = json["site_admin"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["login"] = login;
//     data["id"] = id;
//     data["node_id"] = nodeId;
//     data["avatar_url"] = avatarUrl;
//     data["gravatar_id"] = gravatarId;
//     data["url"] = url;
//     data["html_url"] = htmlUrl;
//     data["followers_url"] = followersUrl;
//     data["following_url"] = followingUrl;
//     data["gists_url"] = gistsUrl;
//     data["starred_url"] = starredUrl;
//     data["subscriptions_url"] = subscriptionsUrl;
//     data["organizations_url"] = organizationsUrl;
//     data["repos_url"] = reposUrl;
//     data["events_url"] = eventsUrl;
//     data["received_events_url"] = receivedEventsUrl;
//     data["type"] = type;
//     data["site_admin"] = siteAdmin;
//     return data;
//   }
// }
