Services
========

les services exposent les pods via des règles réseau.

leurs propriétés:

- ils utilisent des labels pour regrouper les pods
- l'adresse ip est persistante (VIP)
- l'outil kube-proxy sur chaque cluster est en cahrge de
  du load balancing sur les pods, il peut utiliser différentes
  technos pour ça

Il y a plusieurs types de services:

- clusterIP : exposition à l'intérieur du cluster
- NodePort: expose les pods à l'extérieur
- Loadbalancer : intégration dans un cloud provider (aws, etc.)
- ExternalName : permet de faire un mapping avec un DNS


ClusterIP
---------

Permet d'exposer le pod à l'intérieur du cluster, le service ne peut être consommé que par les
éléments du cluster.

spécification

.. code-block::

    serviceApi: v1
    kind: service
    metadata:
        name: vote
    spec:
        selector:  # selecteur des pods, dans ce cas : ceux qui ont le label app avec la valeur "vote"
            app: vote
        type: ClusterIp  #si non noté, type par défaut
        ports:
        - port: 80  # port exposé
          targetPort: 80  #port sur lequel les requetes sont forwardées


NodePort
--------

Permet d'exposer les pods à l'extérieur du cluster. Il expose également les pods à l'intérieur (car
c'est également un ClusterIP).

Un port est ouvert sur chaque noeud du cluster pour un NodePort donné (30 000 et 32 767 par défaut).
Ce port peut être choisi dans le range par défaut, s'il n'est pas choisi, il est attribué automatiquement.


.. code-block::

    serviceApi: v1
    kind: service
    metadata:
        name: vote-np
    spec:
        selector:
            app: vote
        type: NodePort
        ports:
        - port: 80
          targetPort: 80
          nodePort: 31000


LoadBalancer
------------

Service NodePort qui permet la création en plus d'un load balancer, qui sera le point d'entrée de l'application.
Le load balancer est théoriquement à l'extérieur du cluster, et permet la distribution des requêtes via les
différents cluster sur le meme port.

C'est un outil disponible uniquemen chez les cloud providers, car étant à l'extérieur du cluster, le
service ne peut pas être distribué depuis le cluster local...

Il existe tout de même des solutions pour créer un load balancer sur un cluster créé onpremise (metal lb)


.. code-block::

    serviceApi: v1
    kind: service
    metadata:
        name: vote-np
    spec:
        selector:
            app: vote
        type: LoadBalancer
        ports:
        - port: 80
          targetPort: 80
          nodePort: 31000

Commandes impératives
---------------------

expose : si on a un pod déjà en service, on peut directement faire une commande expose

.. code-block::

    kubectl expose pod whoami \
        --type=NodePort \
        --port=8080 \
        --target-port=80 \
        --dry-run=client \
        -o yaml


    kubectl create service nodeport whoami --tcp 8080:80 --dry-run=client -o yaml
    # ne permet pas de choisir le nodeport, k8s le choisira pour nous

    # création de pod + service en meme temps
    kubectl run db --image=mongo:4.2 --port=27027 \
        --expose --dry-run=client -o yaml


Commandes de base
-----------------