import 'dart:convert';

import 'package:http/http.dart' as http;

class FlutterInsta {
  String url = "https://www.instagram.com/";
  String? _followers, _following, _website, _bio, _imgurl, _username;
  // List of images from user feed
  List<String>? _feedImagesUrl;

  //Download reels video
  Future<String> downloadReels(String link) async {
    var linkEdit = link.replaceAll(" ", "").split("/");
    var downloadURL = await http.get(Uri.parse('${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' + "/?__a=1"));
    var data = json.decode(downloadURL.body);
    var graphql = data['graphql'];
    var shortcodeMedia = graphql['shortcode_media'];
    var videoUrl = shortcodeMedia['video_url'];
    return videoUrl; // return download link
  }

  //get profile details
  Future<void> getProfileData(String username) async {
     Map<String, String> _headers = {
      "User-Agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:93.0) Gecko/20100101 Firefox/93.0",
      "Cookie":
          'csrftoken=KwugFcdUbqWmIw5gafx4XceFqG7lL0iy; mid=YXGdmQAEAAGZ8KAkPxbouItPlKZW;ig_did=B1A4CD44-2BC0-46D6-9EA8-183539CC48D0;rur="ASH\0541626909116\0541666509625:01f790737601ddb28113116c4f532ec31a70ba9eed81c465a824b04048f33062c5ad07d8"; ds_user_id=1626909116; sessionid=1626909116%3ASJKuakuknKMwgK%3A29; shbid="13780\0541626909116\0541666509141:01f7550222f10cb6d3fe921d0365f3c16d488e2b5fa5d8df394a2e22bf77b6e58c651ba9"; shbts="1634973141\0541626909116\0541666509141:01f76d9c1887499197411336f50b5e86b6bd269a7d945cef01282c80c8f395ac42412c0f"'
    };
    var res = await http.get(Uri.parse(Uri.encodeFull(url + username + "/channel/?__a=1")), headers: _headers);
    var data = json.decode(res.body);
    var graphql = data['graphql'];
    var user = graphql['user'];
    var biography = user['biography'];
    _bio = biography;
    var myfollowers = user['edge_followed_by'];
    var myfollowing = user['edge_follow'];
    _followers = myfollowers['count'].toString();
    _following = myfollowing['count'].toString();
    _website = user['external_url'];
    _imgurl = user['profile_pic_url_hd'];
    _feedImagesUrl =
        user['edge_owner_to_timeline_media']['edges'].map<String>((image) => image['node']['display_url'] as String).toList();
    this._username = username;
  }

  String? get followers => _followers;

  get following => _following;

  get username => _username;

  get website => _website;

  get bio => _bio;

  get imgurl => _imgurl;

  List<String>? get feedImagesUrl => _feedImagesUrl;
}
