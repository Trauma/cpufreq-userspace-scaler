# cpufreq-userspace-scaler
##### Cpu frequency scaling script for cpufreq userspace governor

## If you're missing ondemand or conservative governors, this script is for you.

This script is scaling cpu frequency according to current average load.
You can set 3 frequency steps : low, mid, high. This 3 thresholds will 
automatically set cpu frequency accordingly :
  - the `lowload` threshold will set the cpu to his minimal frequency, unless you force it to `scalingminfreq`
  - the `midload` threshold will set the cpu to approximate mid range cpu frequency
  - the `highload` threshold will set the cpu to his maximal frequency, unless you force it to `scalingmaxfreq`

If you set `scalingmaxfreq` and/or `scalingminfreq` the cpu will never override those values.

### Usage :
### Parameters :
Variable name   | Default | Type                        | Comments
----------------|---------|-----------------------------|-----------
lowload         | 050     | integer between 000 and 999 | 050 = load average : 0.50
midload         | 065     | integer between 000 and 999 | 065 = load average : 0.65
highload        | 085     | integer between 000 and 999 | 085 = load average : 0.85
scalingminfreq  | auto    | integer in hertz            | 800000 = 800 Mhz
scalingmaxfreq  | auto    | integer in hertz            | 2500000 = 2,5 Ghz

### Default commande line :
`./scaling.sh &`

### Custom command line example :
`lowload=100 highload=200 scalingmaxfreq=2000000 scalingminfreq=1500000 ./scaling.sh &`
