#!/bin/bash
apt install python3-testresources virtualenv
pip3 install "apache-airflow[celery]==2.2.0" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.2.0/constraints-3.6.txt"
