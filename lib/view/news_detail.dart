import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class NewsDetailScreen extends StatefulWidget {
  final String newsImage, newsTitle, newsDate, author, description, content, source;
  const NewsDetailScreen({super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * .45,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newsImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

          Container(
            height: size.height * .6,
            margin: EdgeInsets.only(top: size.height * .4),
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            child: ListView(
              children: [
                Text(widget.newsTitle, style: GoogleFonts.poppins(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w700),),
                SizedBox(height: size.height * .02,),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.source, style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w600),),

                    Text(widget.newsDate, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
