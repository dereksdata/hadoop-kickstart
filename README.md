# hadoop-kickstart
Kickstart snippet for Hadoop RHEL/Centos installation kernel and other low level system settings.

(from http://www.dereksdata.com/single-post/2016/08/18/Safe-Hadoop-Kernel-Configuration-Script)

For ages, I've been looking for someone to produce a nice general purpose script for Linux hosts that sets the optimal kernel settings for a Hadoop node maintained to the current Hadoop release.  While there are a number of scripts out there they tend to be pretty inconsistent or very specific to a particular implementation.
 
Additionally, we needed something that was non-destructive that could be safely run multiple times against the same host without fear of any issues.  Clearly the echo >> /etc/sysctl.conf approach wasn't going to cut it.
 
What I've put together is a script that do the above based upon the current (as of August 2016) Hadoop norms.  It is optimised for 10Gbe networking but should still function fine for 1Gbe.
 
Hopefully, others can also correct, modify and update as we go along.

Current ToDo:
- Verify Tagar's Spark optimisations
- Revalidate Impala disk write cache settings for Impala 2.6
