=========================
Role Bases Access Control
=========================

RBAC a été introduit dans K8s depuis la version 1.5, et est devenu exploitable depuis la 1.8.

Il fourni un mécanisme de restriction à la fois sur les accès et les actions sur les APIs dans
le cluster.

Concept de base de RBAC
    - chaque requete à K8S est `authentifiée`. Cela fourni l'identité de l'appelant
    - kubernetes n'a pas de stockage d'identité propre, il exploite à la place d'autres systèmes
    - une fois qu'un user est identifié, la phase d'authentification détermine s'il est autorisé pour
      réaliser la requête
    - l'autorisation est la combinaison de:
        - l'identité de l'utilisateur
        - la ressource (le path http)
        - le verbe ou l'action demandée

Role Based Acces Control
------------------------

Identité dans K8s
_________________

toute requete à K8s est associée à une identité. Une requête associée à aucune identité
est associée au group ``system:unauthenticated``.

K8s distingue les identités:
- user
- service account

Service Accounts
    Ils sont créés et gérés par K8s, et sont associés en général avec des éléments tournant
    dans le cluster

Users Accounts
    Ce sont tous les autres comptes associés à des utilisateurs, et incluent souvent des automatisations
    (comme par exemple le CICD depuis l'extérieur du cluster)

K8s utilise une interface générique pour l'authentification des utilisateurs : tout utilisateur fourni
un ``username`` et éventuellement un ``group``.

K8s support un certain nombre de fournisseur d'authentification:
- http basic auth (déprécié)
- x509 client certif
- fichiers static de tokens chez l'hote
- Cloud authentification Provider (azure, AWS, GC)
- authentification webhooks

Comprendres les objets Role et Role Binding
___________________________________________


