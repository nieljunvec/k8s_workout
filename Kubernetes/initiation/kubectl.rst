====================
Kubectl tips & ticks
====================

A chaque commande kubectl faite, une commande http est générée et est envoyée à l'api server.

on peut:
- gérer le cluster
- gérer les ressources
- déployer les  workload
- faire du troubleshooting


Approche impérative
    - gérer les ressources en lignes de commandes.
    - Simple, vite, mais pas de suivi comme dans un outil versionné

Approche déclarative
    - utilisé dans la prod
    - un fichier de config pour chaque ressource
    - suivre les changements de chaque ressources
    - utiliser principalement la commande ``apply``
    - mise à jour automatique

Autocomplétion
--------------

Très simple à mettre en place

.. code-block::

    sudo apt-get install bash-completion

    # à placer dans le .bashrc
    source <(kubectl completion bash)

Les ressources
--------------

On peut obtenir l'ensemble des ressources disponibles dans l'API cluster avec la commande:

.. code-block::

    kubectl api-resources


.. csv-table::

    NAME,SHORTNAMES,APIVERSION,NAMESPACED,KIND
    ``bindings``,,v1,true,Binding
    ``componentstatuses``,cs,v1,false,ComponentStatus
    ``configmaps``,cm,v1,true,ConfigMap
    ``endpoints``,ep,v1,true,Endpoints
    ``events``,ev,v1,true,Event
    ``limitranges``,limits,v1,true,LimitRange
    ``namespaces``,ns,v1,false,Namespace
    ``nodes``,no,v1,false,Node
    ``persistentvolumeclaims``,pvc,v1,true,PersistentVolumeClaim
    ``persistentvolumes``,pv,v1,false,PersistentVolume
    ``pods``,po,v1,true,Pod
    ``podtemplates``,,v1,true,PodTemplate
    ``replicationcontrollers``,rc,v1,true,ReplicationController
    ``resourcequotas``,quota,v1,true,ResourceQuota
    ``secrets``,,v1,true,Secret
    ``serviceaccounts``,sa,v1,true,ServiceAccount
    ``services``,svc,v1,true,Service
    ``mutatingwebhookconfigurations``,,admissionregistration.k8s.io/v1,false,MutatingWebhookConfiguration
    ``validatingwebhookconfigurations``,,admissionregistration.k8s.io/v1,false,ValidatingWebhookConfiguration
    ``customresourcedefinitions``,crd crds,apiextensions.k8s.io/v1,false,CustomResourceDefinition
    ``apiservices``,,apiregistration.k8s.io/v1,false,APIService
    ``controllerrevisions``,,apps/v1,true,ControllerRevision
    ``daemonsets``,ds,apps/v1,true,DaemonSet
    ``deployments``,deploy,apps/v1,true,Deployment
    ``replicasets``,rs,apps/v1,true,ReplicaSet
    ``statefulsets``,sts,apps/v1,true,StatefulSet
    ``tokenreviews``,,authentication.k8s.io/v1,false,TokenReview
    ``localsubjectaccessreviews``,,authorization.k8s.io/v1,true,LocalSubjectAccessReview
    ``selfsubjectaccessreviews``,,authorization.k8s.io/v1,false,SelfSubjectAccessReview
    ``selfsubjectrulesreviews``,,authorization.k8s.io/v1,false,SelfSubjectRulesReview
    ``subjectaccessreviews``,,authorization.k8s.io/v1,false,SubjectAccessReview
    ``horizontalpodautoscalers``,hpa,autoscaling/v2,true,HorizontalPodAutoscaler
    ``cronjobs``,cj,batch/v1,true,CronJob
    ``jobs``,,batch/v1,true,Job
    ``certificatesigningrequests``,csr,certificates.k8s.io/v1,false,CertificateSigningRequest
    ``leases``,,coordination.k8s.io/v1,true,Lease
    ``endpointslices``,,discovery.k8s.io/v1,true,EndpointSlice
    ``events``,ev,events.k8s.io/v1,true,Event
    ``flowschemas``,,flowcontrol.apiserver.k8s.io/v1beta2,false,FlowSchema
    ``prioritylevelconfigurations``,,flowcontrol.apiserver.k8s.io/v1beta2,false,PriorityLevelConfiguration
    ``ingressclasses``,,networking.k8s.io/v1,false,IngressClass
    ``ingresses``,ing,networking.k8s.io/v1,true,Ingress
    ``networkpolicies``,netpol,networking.k8s.io/v1,true,NetworkPolicy
    ``runtimeclasses``,,node.k8s.io/v1,false,RuntimeClass
    ``poddisruptionbudgets``,pdb,policy/v1,true,PodDisruptionBudget
    ``podsecuritypolicies``,psp,policy/v1beta1,false,PodSecurityPolicy
    ``clusterrolebindings``,,rbac.authorization.k8s.io/v1,false,ClusterRoleBinding
    ``clusterroles``,,rbac.authorization.k8s.io/v1,false,ClusterRole
    ``rolebindings``,,rbac.authorization.k8s.io/v1,true,RoleBinding
    ``roles``,,rbac.authorization.k8s.io/v1,true,Role
    ``priorityclasses``,pc,scheduling.k8s.io/v1,false,PriorityClass
    ``csidrivers``,,storage.k8s.io/v1,false,CSIDriver
    ``csinodes``,,storage.k8s.io/v1,false,CSINode
    ``csistoragecapacities``,,storage.k8s.io/v1beta1,true,CSIStorageCapacity
    ``storageclasses``,sc,storage.k8s.io/v1,false,StorageClass
    ``volumeattachments``,,storage.k8s.io/v1,false,VolumeAttachment

Documentation des ressources
----------------------------

.. code-block::

    kubectl explain pod

    kubectl explain pod.spec.containers.command

Permet de récupérer une doc terminal des ressources.


Etat d'une ressource
--------------------


.. code-block::

    kubectl get pods

    kubectl get po

    kubectl describe po/www


jsonpath
--------

Utilisé pour récupérer des propriétés dans l'arborescence d'une ressource.

.. code-block::

    kubectl get po/www -o jsonpath='{.spec.containers[0].image}'

    kubectl get pods -n kube-system -o jsonpath='{range.items[*]}{.status.containerStatuses[0].imageID}{"\n"}{end}'


Custom columns
--------------

Les colonnes des descriptions sont prédéfinies. Avec le keyword custom-columns, on peut personnaliser
les colonnes et leur contenu.

.. code-block::

    kubectl get po -o custom-columns='NAME:metadata.name,IMAGES:spec.containers[*].image'


Proxy
-----

permet de créer un pont entre le poste utilisateur et le cluster.

On peut accéder au workload, également aux ressources non exposées à l'extérieur.

.. code-block::

    kubectl proxy