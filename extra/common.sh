# Generate human readable, sortable file timestamp to the second.
# EXAMPLE=$(timestamp); echo $EXAMPLE;
# 2021_05_04__10_31_12
timestamp() { echo "$(date -u +"%Y_%m_%d__%H_%M_%S")"; }
