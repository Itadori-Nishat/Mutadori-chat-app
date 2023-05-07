import 'package:flutter/material.dart';

import 'NETWORK IMAGE.dart';

class ImageFilePage extends StatelessWidget {
  ImageFilePage({Key? key}) : super(key: key);
  NETWORKIMAGE netImg = NETWORKIMAGE();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers:  [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Column(
                children: [],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: netImg.ImagesNetwork.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(1),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.network(netImg.ImagesNetwork[index],fit: BoxFit.cover,)),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
