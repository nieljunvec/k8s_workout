=========
Configmap
=========

Permet de gérer la configuration d'une application:

- découpler la configuration de son application (pas de config dans le code applicatif)
- assure la portabilité
- simplifie la gestion par rapport à l'utilisation de variables d'environnement
- créée à partir d'un fichier, d'un répertoire ou de valeur littérales
- contient une ou plusieurs paires de clé/valeur

Méthode de création
-------------------

A partir d'un fichier
_____________________

Exemple d'une conf nginx. On crée un fichier de configuration pour une conf d'un meme pod.

.. code-block::

    # conf nginx
    user www-data;
    worker_processes 4;
    pid /run/nginx.pid;
    events {
        worker_connections 768;
    }
    http {
        server {
            listen *:8000
            location / {
                proxy_pass http://localhost;
            }
        }
    }


.. code-block::

    # création d'une configmap à partir du fichier
    kubectl create configmap nginx-config --from-file=./nginx.conf

    # récupération des infos de la ressource
    kubectl get cm nginx-config -o yaml

A partir d'un fichier d'environnement
_____________________________________


.. code-block::

    # fichier d'environnement
    log_level=WARN
    env=production
    cache=redis

.. code-block::

    # création d'une configmap
    kubectl create configmap app-config-env --from-env-file=./app.env

    # récupération des infos de la ressources
    kubectl get cm app-config-env -o yaml

A partir de valeurs littérales
______________________________

.. code-block::

    kubectl create cm app-config-lit \
        --from-literal=log_level=WARN \
        --from-literal=env=dev \
        --from-literal=cache=redis

Utilisation dans un pod
-----------------------

Ajout d'un fichier
__________________

Dans la création d'un pod, on va placer un volume qui va se référer à la configmap crée.

.. code-block::

    apiVersion: v1
    kind: Pod
    metadata:
        name: www
    spec:
        containers:
        - name: proxy
          image: nginx
          ports:
          - containerPort: 8000
          volumeMounts:
          - name: config  # montage du volume dans le container
            mountPath: "/etc/nginx"
        - name: api
          image: lucj/city:1.0
          ports:
          - containerPort: 80
        volumes:
        - name: config  # définition d'un volume basé sur la configmap
          configMap: nginx-config

Ajout d'une variable d'environnement
____________________________________

.. code-block::

    apiVersion: v1
    kind: Pod
    metadata:
        name: w3
    spec:
        containers:
        - name: www
          image: nginx
          ports:
          - containerPort: 8000
          env:
          - name: LOG_LEVEL
            valueFrom:
              configMapKeyRef:
                name: app_config-lit
                key: log_level
          - name: CACHE
            valueFrom:
              configMapKeyRef:
                name: app_config-env
                key: cache