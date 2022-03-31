#!/bin/bash

current_doc = &1

sudo rm -Rf /var/www/$current_doc

mv _build /var/www/$current_doc