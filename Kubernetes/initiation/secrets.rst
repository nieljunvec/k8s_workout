===========
Les secrets
===========

- Permet de gérer les données sensibles: clé privé, mdp, etc.
- découple les application de ces informations
- donne un meilleur controle sur leur utilisation
- créé par un utilisateur ou par le système
- utilisé dans un pod:
    - via un volume monté dans un ou plusieurs containers
    - via kubelet lors de la récupération de l'image
- stocké dans etcd

Il y a différents types de secrets:
- le generic
- le docker-registry : auth auprès d'un registry
- le TLS : gérer clé privé et certif associé



Secret de type "generic"
------------------------


.. code-block:: shell

    # création de fichiers contenant des credentials
    echo -n "admin" > ./username.txt
    echo -n "45fe3efa" > ./password.txt

    # création de l'objet Secret avec kubectl
    kubectl create secret generic service-creds --from-file=./username.txt --from-file=./password.txt

    # création depuis des valeurs litterales
    kubectl create secret generic service-creds2 \
        --from-literal=username=admin --from-literal=password=45fe3efa

    # liste des Secrets présents
    kubectl get secrets


Pour avoir les information sur un secret:

.. code-block::

    # inspection du contenu de l'objet
    kubectl describe secret/service-creds

    # détail de la specification de l'objet
    kubectl get secrets service-creds -o yaml

Les secrets sont encodés en base64, on peut les récupérer avec

.. code-block::

    echo "{mdp encodé}" | base64 -D

Exemple
_______

.. code-block::

    # conversion de la donnée en b64
    echo -n "mongodb://admin:46fe3efa@mgserv1.org/mgmt" | base64

    # spécification de l'objet secret
    # mongo-creds.yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: mongo-creds
    data:
      mongoURL: bW9uZ29kYjovL2FkbWluOjQ2ZmUzZWZhQG1nc2VydjEub3JnL21nbXQ=

    # création de l'objet secret
    kubectl create -f mongo-creds.yaml


Les Secrets de type ``docker-registry``
---------------------------------------


Les secrets de type ``tls``
---------------------------

