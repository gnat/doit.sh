# Removes all __pycache__, *.pyc, *.pyo
find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
