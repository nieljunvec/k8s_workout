=========
DaemonSet
=========

Permet de définir une spécification de pod, et de s'assurer qu'un pod avec cette spécification de spécification
tournera sur chaque noeud du Cluster (meme si un nouveau node est ajouté par la suite).

Exemples de cas d'usage:
- collecte de logs
- monitoring
- stockage

Exemple de spécification:

.. code-block:: yaml

    apiVersion: apps/v1
    kind: DaemonSet
    # minimum le name, on peut ajouter labels & cie
    metadata:
        name: www
    spec:
        # spécification des caractéristiques du pod exploité.
        template:
            metadata:
                labels:
                    app: web
            spec:
                containers:
                - name: www
                  image: nginx
                  ports:
                  - containerPort: 80

Exposition de metric de chaque Pod
==================================

Le but du daemonSet est de lancer un pod sur chaque machine du cluster. Le pod sera en charge de récupérer
des metrics de la machine en question, et de les exposer.


.. code-block:: yaml

    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: node-exporter
    spec:
      template:
        metadata:
          labels:
            app: node-exporter
          name: node-exporter
        spec:
          hostNetwork: true
          hostPID: true
          containers:
          - image:  quay.io/prometheus/node-exporter:NODE_EXPORTER_VERSION
            args:
            - "--path.procfs=/host/proc"
            - "--path.sysfs=/host/sys"
            name: node-exporter
            ports:
            - containerPort: 9100
              hostPort: 9100
              name: scrape
            resources:
              requests:
                memory: 30Mi
                cpu: 100m
              limits:
                memory: 50Mi
                cpu: 200m
            volumeMounts:
            - name: proc
              readOnly:  true
              mountPath: /host/proc
            - name: sys
              readOnly: true
              mountPath: /host/sys
          tolerations:
            - effect: NoSchedule
              operator: Exists
          volumes:
          - name: proc
            hostPath:
              path: /proc
          - name: sys
            hostPath:
              path: /sys