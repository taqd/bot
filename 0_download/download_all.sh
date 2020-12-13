#!/bin/bash

ssh  -i /home/tdwyer/.ssh/google_compute_engine tyler@35.203.59.152 'cd bot; make run'
ssh  -i /home/tdwyer/.ssh/google_compute_engine tyler@35.203.102.248 'cd bot; make run'
