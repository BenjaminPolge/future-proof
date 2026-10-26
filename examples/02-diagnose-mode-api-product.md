# Diagnose mode — a quick read on an existing product

**Prompt** (the user writes in French, so the verdict comes back in French)

```
Fais le test des 10x sur ce repo : c'est notre API de données cadastrales, avec un
serveur MCP et une petite interface web.
```

```
Test future-proof — API de données cadastrales

Horizon      3 mois  6 mois  12 mois
Note /10       8       8        9

Critères (vue à 12 mois)
🟢 Profite des progrès des modèles — Des agents plus capables feront plus de requêtes,
                                     pas moins.
🟢 Exposition à l'échafaudage      — Presque pas de code IA : la valeur est dans la donnée
                                     et son actualisation.
🟢 Prêt pour les agents            — Le serveur MCP et l'API structurée existent déjà.
🟠 Pari coût et latence            — La facturation au nombre d'appels humains devra suivre
                                     un trafic d'agents bien plus élevé.
⚪ Fusion des modalités            — Sans objet.
🟢 Chevauchement agent persistant  — L'outil est une source pour les agents, pas un
                                     concurrent.
🟢 Avantage durable                — Données consolidées et mises à jour : un modèle
                                     10x meilleur ne les a pas.

Verdict : le produit gagne à mesure que les agents se répandent. Le seul risque est la
tarification, pensée pour des humains.
```

The 12-month score is 7 or more, so there is no revised plan. In diagnose mode the agent
stops here.
