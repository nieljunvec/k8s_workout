Deployments
===========

En général on ne déploie pas des pods directements, mais à partir
de ressources de plus haut niveau, dont les deployements.

Un deployment permet de gérer un ensemble de pods identiques
et de s'assurer qu'on a constamment un nombre identique de pods (scaling).

ça permet de faire évoluer les pods (version 1 à 2 par ex).

Spécifications
--------------

On peut:
    - créer/supprimer
    - gérer le scaling
    - maj (rollout, rolling update), rollback


il y a différent niveau d'application:
    - le deployment
    - le replicaSet
    - le pod

Le replicaSet est une ressource intermédiaire : vérifie continuellement
que tout tourne.


.. code-block::

    # section deployment
    apiVersion: apps/v1  # version différente de v1
    kind: Deployment
    metadata:
      labels:
        app: test
      name: test
    spec:
      # section replicaSet
      replicas: 1  # nb de pods identiques
      selector:  # permet de spécifier les pods gérés par le deployment
        matchLabels:
          app: test
      strategy: {}
      template:
        metadata:
          labels:
            app: test
        # section pod
        spec:
          containers:
          - image: nginx
            name: nginx
            ports:
            - containerPort: 80
            resources: {}
    status: {}

Approche impérative
-------------------

.. code-block::

    kubectl create deploy vote --image instavote/vote \
        --dry-run=client \
        -o yaml


Exercices
---------

`Lien  <../k8s-exercices/Deployment/deployment_gost.md>`_


Mise à jour
-----------

Il suffit de modifier le fichier du deployment, et de relancer:

.. code-block::

    kubectl apply -f file.yml

La réponse de kubectl sera "deployment.app/file configured"


Mise à l'échelle - scaling horizontal
-------------------------------------

Modifier le scaling à la main.

.. code-block::

    kubectl scale deploy/www --replicas=5


HorizontalPodAutoscaler
-----------------------


outil permettant de modifier le scaling en fonction de la charge, de façon automatique.
