% In order to run MSE-HOT on the Bruker system take the following steps:
%   1) copy the binary file you just downloaded
%
%   from:
%   ~\MSE-HOT thermometry\Bruker files\Paravision Method and ppg -
%   MSE-HOT\RMD_HOT\RMD_HOT.so
%   
%   into: /opt/PV5.1/prog/parx/pub
%
%   2) copy the .ppg file from
%   ~\MSE-HOT thermometry\Bruker files\Paravision Method and ppg - MSE-HOT
%   \RMD_HOT_2D_RARE_ZQSQ2.ppg
%
%   into: /opt/PV5.1/exp/stan/nmr/lists/pp
%
%   3) copy the HOT protocol files (all 3) from
%   ~\MSE-HOT thermometry\Bruker files\Bruker protocols
%   
%   into: /opt/PV5.1/exp/stan/nmr/parx/routine/<configuration>/<any folder you choose>
%   NOTE: The folder <configuration> varies from system to system, and I have no way
%   of knowing what the configuration is on your scanner.  For me <configuration>=S116
%   If the protocols do not appear after copying them into the above folder, then probably
%   the configuration (e.g. S116) folder is wrong.  Try searching for the
%   names of existing protocols using the linux "find" command to see the
%   proper location for the protocol files.  contact me if you need
%   assistance, or if you are not familiar with how paravision protocols
%   work.