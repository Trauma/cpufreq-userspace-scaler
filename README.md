# cpufreq-userspace-scaler
##### Cpu frequency scaling script for cpufreq userspace governor

## If you're missing ondemand or conservative governors, this script is for you.

This script is scaling cpu frequency according to current average load.
You can set 2 frequency steps : low, mid. This 2 thresholds will automatically set cpu frequency accordingly :
  - the `lowload` threshold will set the cpu to his minimal frequency, unless you force it to `scalingminfreq`
  - the `midload` threshold will set the cpu to approximate mid range cpu frequency, if load goes higher it will scale to max `scalingmaxfreq`

If you set `scalingmaxfreq` and/or `scalingminfreq` the cpu will never override those values.

### Usage :
### Parameters :
Variable name   | Default | Type                        | Comments
----------------|---------|-----------------------------|-----------
lowload         | 050     | integer between 000 and 999 | 050 = load average : 0.50
midload         | 065     | integer between 000 and 999 | 065 = load average : 0.65
scalingminfreq  | auto    | integer in hertz            | 800000 = 800 Mhz
scalingmaxfreq  | auto    | integer in hertz            | 2500000 = 2,5 Ghz

### Default commande line :
`./scaling.sh &`

### Custom command line example :
`lowload=100 midload=200 scalingmaxfreq=2000000 scalingminfreq=1500000 ./scaling.sh &`

### Systemd service installer
*for DSM 7.0 and above*

1. If needed, set desired lowload and midload values in `cpufreq-userspace-scaler.service`
2. Launch the installer `./install.sh`
