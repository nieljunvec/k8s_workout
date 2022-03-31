Namespaces
==========


Un namespace permet d'isoler un sensemble de ressources, cela permet de partager un cluster (plusieurs
agents, clients, etc.), en approche multi-tenant.

Par défaut on a 3 namespaces:

- default (celui utilisé si pas de précision)
- kube-public
- kube-system

Création
--------

Par commande

.. code-block::

    kubectl create namespace development

    kubectl delete namespace development


On peut aussi le créer par notification

.. code-block:: yaml

    # development.yaml
    apiVersion: v1
    kind: Namespace
    metadata:
        name: development
        labels:
            name: development

puis lancer la commande

.. code-block:: bash

    kubectl create -f development.yaml


Utilisation
-----------

Pour attacher un pod à un namespace, on a plusieurs possibilités:

- on peut le préciser dans les métadatas de la spécification

.. code-block::

    apiVersion: v1
    kind: Pod
    metadata:
        name: nginx
        namespace: development
    spec:
        containers:
        - image: nginx:1.12.2
          name: www

- indiquer le ns dans la commande impérative

Ajout dans un contexte
----------------------

un contexte est principalement trois choses:
- un nom de cluster
- un nom d'utilisateur
- le namespace

le namespace est par défaut non indiqué (car c'est le ns default).

on peut le préciser:

.. code-block::

    # vérification du contexte courant
    kubectl config current-context

    # définition du ns development dans le contexte courant
    kubectl config set-context $(kubectl config current-context) --namespace=development

    # vérification du changement
    kubectl config view


