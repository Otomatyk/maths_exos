<!-- // ## Comment s'organise une feuille d'exercices et comment en créer ?

// Une feuille d'exercices est un ensemble d'exercices (en général, entre 3 et 7) avec leur correction, [libre à vous de choisir le thème de la feuille générée,  un "Développement" "Equations du second degré"]

// Une feuille d'exercices est un ensemble d'exercices (en général, entre 3 et 7) avec leur correction.
// Pour générer vos feuilles, deux options s'ouvrent à vous :
// - Choisir une ou plusieurs "rubriques", une rubrique est un ensemble d'exerices choisis aléatoirement, selon plusieurs critères :

//  -->

```json
{
  "arithemetic": {
    "distributivity": {
      "factorization": [
        "factorisation_first_degree",  "factorisation_first_degree_complex",
        "factorisation_second_degree", "factorisation_second_degree",
      ],

      "developpement": [
        "developpement_first_degree",  "developpement_first_degree_complex",
      ]
    }
  }
}

{
  "title": "Developpement et factorisation",
  "correction_kind": "none" | "same_file" | "other_file",

  "content": [
    {
      "type": "rubrique",
      "topics": [
        "developpement_first_degree", 
        "factorisation_first_degree",
        "developpement_first_degree_complex"
      ],
      "kind":  "testing" | "training" | "complete",
      "numbers": ["negative"],
      // This number is doubled if the kind is "complete"
      "question_per_topic": 2
    },

    {
      "type": "true_or_false",
      "topic": "developpement_first_degree_complex",
      "numbers": ["fraction", "negative"]
    },
  ]
}
```