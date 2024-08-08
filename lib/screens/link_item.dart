import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/link.dart';
import '../../services/link_service.dart';
import '../../widgets/custom_yes_no_dialog.dart';

typedef LinkOperationCallback = void Function(Link updatedLink);

class LinkItem extends StatelessWidget {
  final Link link;
  final LinkOperationCallback onUpdate;
  final LinkOperationCallback onDelete;
  LinkItem({super.key, required this.link, required this.onUpdate, required this.onDelete});

  final LinkService linkService = LinkService();
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: const Color(0xff273085),
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            onPressed: (BuildContext context) {
              _showUpdateDialog(link, context);
            },
          ),
          SlidableAction(
            backgroundColor: const Color(0xffE47B73),
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            onPressed: (BuildContext context) async {
              _showDeleteDialog(context);
            },
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _launchInBrowser(link.link_url);
        },
        child: Container(
            padding: const EdgeInsets.only(top: 18, left: 15, bottom: 18),
            decoration: const BoxDecoration(
              color: Color(0xfff5f5f5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              link.title,
                              style: const TextStyle(
                                color: Color(0xff273085),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              link.link_url,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Row(
                  children: [
                    SizedBox(width: 5,),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 10,),
                    SizedBox(width: 5,),
                  ],
                ),
              ],
            ))
      ),
    );
  }

  Future<void> _showUpdateDialog(Link link, BuildContext context) async {
    TextEditingController titleController = TextEditingController(text: link.title);
    TextEditingController linkUrlController = TextEditingController(text: link.link_url);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Mise à jour',
            style: TextStyle(color: Color(0xff273085)),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Titre: '),
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir un titre';
                      } else if (value.length > 20) {
                        return 'Le titre doit contenir au plus 20 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('Lien: '),
                  TextFormField(
                    controller: linkUrlController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir une URL';
                      } else if (Uri.parse(value).host.isEmpty) {
                        return 'Veuillez saisir une URL valide';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler', style: TextStyle(color: Color(0xff273085))),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await linkService.updateLink(link.id, titleController.text, linkUrlController.text);
                  onUpdate(Link(id: link.id, title: titleController.text, link_url: linkUrlController.text));
                  Navigator.pop(context);
                }
              },
              child: const Text('Appliquer', style: TextStyle(color: Color(0xff273085))),
            ),
          ],
        );
      },
    );
  }


  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomYesNoDialog(
          title: 'Supprimer le lien',
          content: 'Êtes-vous sûr?',
          onYesPressed: () async {
            await linkService.deleteLink(link.id);
            onDelete(link);
            Navigator.pop(context);
          },
          primaryColor: const Color(0xffE47B73),
        );
      },
    );
  }

  Future<void> _launchInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $uri');
    }
  }


}
