import 'package:flutter/material.dart';
import 'profession.dart';

const List<Profession> kStaticProfessions = [
  Profession(
    id: 'medecin_generaliste',
    slug: 'medecin_generaliste',
    name: 'Médecin généraliste',
    description: 'Consultations médicales, diagnostics, ordonnances et suivi de santé à domicile.',
    iconData: Icons.medical_services_rounded,
  ),
  Profession(
    id: 'pediatre',
    slug: 'pediatre',
    name: 'Pédiatre',
    description: 'Suivi de croissance, santé des nourrissons, enfants et adolescents.',
    iconData: Icons.child_care_rounded,
  ),
  Profession(
    id: 'sage_femme',
    slug: 'sage_femme',
    name: 'Sage-femme',
    description: 'Suivi prénatal, préparation à l’accouchement, soins post-partum mère et bébé.',
    iconData: Icons.pregnant_woman_rounded,
  ),
  Profession(
    id: 'kinesitherapeute',
    slug: 'kinesitherapeute',
    name: 'Kinésithérapeute',
    description: 'Rééducation motrice, kinésithérapie respiratoire, massages thérapeutiques.',
    iconData: Icons.accessibility_new_rounded,
  ),
  Profession(
    id: 'infirmiere',
    slug: 'infirmiere',
    name: 'Infirmière / Infirmier',
    description: 'Injections, pansements, prélèvements sanguins, perfusions et soins continus.',
    iconData: Icons.healing_rounded,
  ),
  Profession(
    id: 'aide_soignante',
    slug: 'aide_soignante',
    name: 'Aide-soignante / Garde-malade',
    description: 'Aide aux actes essentiels, hygiène, confort, mobilité et maintien à domicile.',
    iconData: Icons.volunteer_activism_rounded,
  ),
];
