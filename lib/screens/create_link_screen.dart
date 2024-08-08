import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saiphadminfinal/models/link.dart';
import 'package:saiphadminfinal/services/link_service.dart';

class CreateLinkScreen extends StatefulWidget {
  const CreateLinkScreen({Key? key}) : super(key: key);

  @override
  _CreateLinkScreenState createState() => _CreateLinkScreenState();
}

class _CreateLinkScreenState extends State<CreateLinkScreen> {
  final LinkService linkService = LinkService();
  List<Link> linkInputs = [Link(title: '', link_url: '')];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Ajouter des liens',
          style: TextStyle(color: Color(0xff273085)),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xff273085),
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: List.generate(linkInputs.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Titre (max. 20 caractères): ',
                          style: TextStyle(
                            color: Color(0xff273085),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextFormField(
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir un titre';
                            } else if (value.length > 20) {
                              return 'Le titre doit contenir au plus 20 caractères';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              linkInputs[index].title = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lien: ',
                          style: TextStyle(
                            color: Color(0xff273085),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir une URL';
                            } else if (Uri.parse(value).host.isEmpty) {
                              return 'Veuillez saisir une URL valide';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              linkInputs[index].link_url = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        if (linkInputs.length > 1)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  linkInputs.removeAt(index);
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff273085),
        elevation: 0,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              linkInputs.add(Link(title: '', link_url: ''));
            });
          }
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: [
        Center(
          child: TextButton(
            style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
            onPressed: () {
              _saveLinks();
            },
            child: const Text(
              'Enregistrer',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Inter',
                color: Color(0xff273085),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveLinks() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        await Future.forEach(linkInputs, (Link link) async {
          await linkService.createLink(link.title, link.link_url);
        });

        Navigator.of(context).pop(true);
      } catch (e) {
        print('Error saving links: $e');
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

}
