import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stocktrue/ip.dart';

// ignore: must_be_immutable
class AddVenDetail extends StatefulWidget {
  String idvente = '';
  AddVenDetail(this.idvente, {super.key});

  @override
  State<AddVenDetail> createState() => _AddVenDetailState();
}

class _AddVenDetailState extends State<AddVenDetail> {
  TextEditingController codevente = TextEditingController();
  TextEditingController codeproduit = TextEditingController();
  TextEditingController quantite = TextEditingController();
  TextEditingController prixu = TextEditingController();
  List<Achatdetail> clients = [];
  Map<String, dynamic> once = {};
  String client = "";
  List data = [];
  // ignore: prefer_typing_uninitialized_variables
  var selectedname;
  // ignore: prefer_typing_uninitialized_variables
  var selectedvalue;
  // ignore: prefer_typing_uninitialized_variables
  var seleccat;
  // String adress = currentip();
  Future<void> getrecord() async {
    var url = "$Adress_IP/PRODUIT/getproduit.php";
    try {
      var response = await http.get(Uri.parse(url));
      setState(() {
        data = jsonDecode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              // hint: const Text("Select client"),
              items: data.map((list) {
                return DropdownMenuItem(
                  value: list["id_produit"],
                  child: Text(list["designation"]),
                );
              }).toList(),
              //onChanged: onChanged,
              value: selectedvalue,
              icon: const Icon(Icons.arrow_drop_down_circle),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.production_quantity_limits),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  hintText: "Produit",
                  labelText: "Produit"),
              onChanged: (value) {
                selectedvalue = value;
                client = selectedvalue;
                setState(() {
                  selectedname = selectedvalue;
                });

                print(selectedname);
              },
            ),
            TextField(
              controller: quantite,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.production_quantity_limits_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  hintText: "Quantite",
                  labelText: "Quantite"),
            ),
            TextField(
              controller: prixu,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.monetization_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  hintText: "Prix de l'article",
                  labelText: "Prix"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  clients.add(Achatdetail(
                    codeproduit: int.parse(selectedname),
                    quantite: int.parse(quantite.text),
                    prixu: double.parse(prixu.text),
                    codevente: int.parse(widget.idvente),
                  ));
                });
                // Efface les champs après l'ajout
                codeproduit.clear();
                quantite.clear();
                prixu.clear();
              },
              child: const Text('Ajouter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Affiche les données au format JSON
                // print(clients.map((client) => client.toJson()).toList());
                // print(clients);
                List j = clients.map((e) => e.toJson()).toList();
                print(j);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}

class Achatdetail {
  int codevente;
  int codeproduit;
  int quantite;
  double prixu;

  Achatdetail(
      {required this.codeproduit,
      required this.quantite,
      required this.codevente,
      required this.prixu});

  Map<String, dynamic> toJson() {
    return {
      'vente_id': codevente,
      'produit_id': codeproduit,
      'quantite': quantite,
      'prixu': prixu,
    };
  }
}
