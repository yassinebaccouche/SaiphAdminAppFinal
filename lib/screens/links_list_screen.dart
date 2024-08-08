import 'package:flutter/material.dart';
import 'package:saiphadminfinal/models/link.dart';
import 'package:saiphadminfinal/services/link_service.dart';
import 'package:saiphadminfinal/screens/link_item.dart';
import 'create_link_screen.dart';


class LinksListScreen extends StatefulWidget {
  const LinksListScreen({Key? key}) : super(key: key);

  @override
  State<LinksListScreen> createState() => _LinksListScreenState();
}

class _LinksListScreenState extends State<LinksListScreen> {
  final LinkService linkService = LinkService();
  late List<Link> linkInputs;
  late bool isLoading;
  late bool isError;

  @override
  void initState() {
    super.initState();
    linkInputs = [];
    isLoading = true;
    isError = false;
    fetchLinks();
  }

  Future<void> fetchLinks() async {
    try {
      final links = await linkService.fetchLinks().first;
      setState(() {
        linkInputs = links;
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  Future<void> _refreshLinks() async {
    await fetchLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Liens',
          style: TextStyle(color: Color(0xff273085)),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xff273085),
        onRefresh: _refreshLinks,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xfff5f5f5)))
            : isError
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Une erreur s\'est produite'),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: fetchLinks,
              ),
            ],
          ),
        )
            : (linkInputs.isEmpty
            ? Center(child: Text('Aucun lien n\'a été ajouté'))
            : ListView.builder(
          itemCount: linkInputs.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: LinkItem(link: linkInputs[index],onUpdate: (updatedLink) {
                setState(() {
                  linkInputs[index] = updatedLink;
                });
              },
                onDelete: (deletedLink) {
                setState(() {
                  linkInputs.removeWhere((element) => element.id == deletedLink.id);
                });
              },),
            );
          },
        )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff273085),
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateLinkScreen(),
            ),
          ).then((value) {
            if (value == true) {
              _refreshLinks();
            }
          });
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
