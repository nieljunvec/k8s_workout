====
Tabs
====

Installation
============

Pour présenter une solution de code ou simplement un élément de documentation en différents onglet,
on peut utiliser sphinx-tabs.

.. code-block:: bash

    pip install sphinx-tabs


Pour le mettre en place, il est nécessaire de mettre à jour le fichier conf.py

.. code-block::

    extensions = [
        'sphinx_tabs.tabs'
    ]

Il y a des options possibles

.. code-block:: python

    # par défaut les tabs peuvent être fermées, pour l'empêcher
    sphinx_tabs_disable_tab_closing = True

    # pour désactiver le css dédié par défaut
    sphinx_tabs_disable_css_loading = True


Exemple
=======


.. code-block::

    .. tabs::

        .. tab:: Pomme

            La pomme est verte

        .. tab:: Poire

            La poire est rouge

        .. tab:: Orange

            L'orange est orange


.. tabs::

        .. tab:: Pomme

            La pomme est verte

        .. tab:: Poire

            La poire est rouge

        .. tab:: Orange

            L'orange est orange