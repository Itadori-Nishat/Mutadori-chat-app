import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostDecorationUI extends StatefulWidget {
  String? postUserName;
  Image? postUserImage;
  String? userPostImage;
  PostDecorationUI({Key? key, this.postUserName, this.postUserImage, this.userPostImage}) : super(key: key);

  @override
  State<PostDecorationUI> createState() => _PostDecorationUIState();
}

class _PostDecorationUIState extends State<PostDecorationUI> {
  bool _isFollowing = false;
  bool _isTappedIcon = false;
  bool _isTappedBookmark = false;
  int likecount = 0;
  void _toggleLike() {
    setState(() {
      _isTappedIcon = !_isTappedIcon;
      if (_isTappedIcon) {
        likecount++;
      } else {
        likecount--;
      }
    });
  }
  String comments = "BeautifulContains code to deal with internationalized/localized messages, "
      "date and number formatting and parsing, bi-directional text, and other internat"
      "ionalization issues.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,color: Colors.black,),
          onPressed: (){Navigator.pop(context);},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Posts", style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500
        ),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){},
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: widget.postUserImage,),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text("${widget.postUserName}",style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500
                        ),)
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              shadowColor: MaterialStatePropertyAll(Colors.transparent),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade300
                              )
                          ),
                          onPressed: (){
                            setState(() {
                              _isFollowing = !_isFollowing;
                            });
                          },
                          child: Text(_isFollowing? "Following" : "Follow",style: TextStyle(
                              color: Colors.black
                          ),)),
                      IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.more_vert))
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onDoubleTap: _toggleLike,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height*0.65,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: "${widget.userPostImage}",
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Likes - comments - share
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _toggleLike,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(_isTappedIcon?Icons.favorite:
                                Icons.favorite_border,
                                  color: _isTappedIcon? Colors.red: Colors.black, size: 30,),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){ },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset("Assets/comment_icon.png", height: 26,),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset("Assets/send_icon.png", height: 26,),
                              ),
                            )
                          ],
                        ),
                        IconButton(onPressed: (){
                          setState(() {
                            _isTappedBookmark = !_isTappedBookmark;
                          });
                        },
                            icon: Icon(_isTappedBookmark?Icons.bookmark: Icons.bookmark_border, size: 30,))
                      ],
                    ),
                    //Like count
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Text("${likecount}",style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),),
                          SizedBox(width: 5,),
                          Text("Likes",style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),),
                        ],
                      ),
                    ),
                    //Comments
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text("${widget.postUserName}", style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),),

                        ],
                      ),
                    ),
                    //Date
                    Text("10 April 2023",style: TextStyle(
                        fontSize: 10
                    ),),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
