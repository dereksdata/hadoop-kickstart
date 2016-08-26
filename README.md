# hadoop-kickstart

**Optimised kernel and network settings configuration script for Hadoop installed on RHEL/Centos.**

General purpose script for Linux hosts that sets the optimal kernel settings for a Hadoop node maintained to the current Hadoop release. Can be used as part of a kickstart build. Non-destructive and can be safely run multiple times against the same host without fear of misconfiguration.

This is a collaboratively developed script that do the above based upon the current (as of August 2016) Hadoop norms.  It is optimised for 10Gbe networking but should still function fine for 1Gbe.

(from http://www.dereksdata.com/single-post/2016/08/18/Safe-Hadoop-Kernel-Configuration-Script)
